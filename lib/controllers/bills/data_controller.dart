import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/services/api_service.dart';
import 'package:tekpayapp/services/api_exception.dart';
import 'package:tekpayapp/models/data_plan_model.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/pages/app/airtime/transaction_status_page.dart';

class DataController extends GetxController {
  final _api = ApiService();
  final _userController = Get.find<UserController>();
  final plans = Rx<DataPlanResponse?>(null);
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final String serviceId;
  final Map<String, String> serviceIds = {
    'MTN': 'mtn-data',
    'GLO': 'glo-data',
    'AIRTEL': 'airtel-data',
    '9MOBILE': '9mobile-data',
  };

  DataController(this.serviceId);

  @override
  void onInit() {
    super.onInit();
    fetchDataPlans();
  }

  Future<void> fetchDataPlans() async {
    try {
      isLoading.value = true;
      final response = await _api.get('bills/data/plans/$serviceId');

      if (response['status'] == true) {
        plans.value = DataPlanResponse.fromJson(response['data']);
      } else {
        throw ApiException(
          statusCode: 0,
          message: response['message'] ?? 'Failed to fetch data plans',
        );
      }
    } on ApiException catch (e) {
      print('API Error fetching data plans: ${e.message}');
      Get.snackbar(
        'Error',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error fetching data plans: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch data plans',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> purchaseData({
    required String phone,
    required String amount,
    required String variationCode,
    required String pin,
  }) async {
    try {
      // Validate phone number
      if (phone.isEmpty || phone.length < 10) {
        throw 'Invalid phone number';
      }

      // Validate amount
      final amountValue = double.tryParse(amount);
      if (amountValue == null || amountValue <= 0) {
        throw 'Invalid amount';
      }

      // Validate PIN
      if (pin.isEmpty || pin.length != 4) {
        throw 'Invalid PIN';
      }

      // Verify PIN with user profile
      final userModel = _userController.user.value;
      if (userModel == null || userModel.profile.pinCode.toString() != pin) {
        throw 'Invalid transaction PIN';
      }

      isLoading.value = true;

      try {
        final response = await _api.post('bills/data/purchase', body: {
          'phone': phone,
          'billersCode': phone,
          'serviceID': serviceId,
          'variation_code': variationCode,
          'amount': amount,
          'pin': pin,
        });

        print('API Response: $response'); // Debug print

        if (response['status'] == true) {
          final transactionData = response['data'];
          final status = transactionData['status']?.toString() ?? '';

          // Refresh user profile after successful request
          await _userController.getProfile();

          if (status == 'pending') {
            final requestId = transactionData['requestId'];
            // Check transaction status
            await _checkTransactionStatus(
              requestId: requestId,
              amount: transactionData['amount'],
              reference: transactionData['reference'],
              date: transactionData['transaction_date'],
              phone: transactionData['phone'],
              network: transactionData['network'],
              productName: transactionData['product_name'],
            );
            return;
          }

          Get.off(() => TransactionStatusPage(
                status: _getTransactionStatus(status),
                amount: transactionData['amount'],
                reference: transactionData['reference'],
                date: transactionData['transaction_date'],
                recipient: transactionData['phone'],
                network: transactionData['network'].split('-')[0].toUpperCase(),
                productName: transactionData['product_name'],
              ));
        } else {
          throw response['message'] ?? 'Failed to purchase data plan';
        }
      } catch (e) {
        print('API Error: $e'); // Debug print
        rethrow;
      }
    } catch (e) {
      print('Error purchasing data plan: $e');
      Get.back(); // Close pin dialog
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _checkTransactionStatus({
    required String requestId,
    required String amount,
    required String reference,
    required String date,
    required String phone,
    required String network,
    required String productName,
  }) async {
    try {
      final response = await _api.post('bills/status', body: {
        'request_id': requestId,
      });

      if (response['status'] == true && response['data'] != null) {
        final statusData = response['data'];
        final status = statusData['status']?.toString() ?? '';

        // Refresh user profile after getting status
        await _userController.getProfile();

        // If still pending, show pending status with original transaction data
        if (status == 'pending') {
          Get.off(() => TransactionStatusPage(
                status: TransactionStatus.pending,
                amount: amount,
                reference: reference,
                date: date,
                recipient: phone,
                network: network.split('-')[0].toUpperCase(),
                productName: productName,
              ));
          return;
        }

        // Show final status with updated transaction data
        Get.off(() => TransactionStatusPage(
              status: _getTransactionStatus(status),
              amount: statusData['amount'] ?? amount,
              reference: statusData['reference'] ?? reference,
              date: statusData['transaction_date'] ?? date,
              recipient: statusData['phone'] ?? phone,
              network: (statusData['network'] ?? network)
                  .split('-')[0]
                  .toUpperCase(),
              productName: statusData['product_name'] ?? productName,
            ));
      } else {
        throw response['message'] ?? 'Failed to get transaction status';
      }
    } catch (e) {
      print('Error checking transaction status: $e');
      Get.snackbar(
        'Error',
        'Failed to check transaction status',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  TransactionStatus _getTransactionStatus(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return TransactionStatus.success;
      case 'initiated':
      case 'pending':
        return TransactionStatus.pending;
      case 'failed':
        return TransactionStatus.failed;
      default:
        return TransactionStatus.failed;
    }
  }

  List<DataPlanVariation> get filteredPlans {
    if (plans.value == null) return [];

    final query = searchQuery.value.toLowerCase();
    return plans.value!.variations.where((plan) {
      return plan.name.toLowerCase().contains(query);
    }).toList();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  double getDiscountedPrice(String amount) {
    // Apply 2% discount
    final originalPrice = double.tryParse(amount) ?? 0.0;
    return originalPrice * 0.98;
  }
}
