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

      isLoading.value = true;

      try {
        final response = await _api.post('bills/data/purchase', body: {
          'phone': phone,
          'serviceID': serviceId,
          'billersCode': phone,
          'variation_code': variationCode,
          'amount': amount,
          'pin': pin,
        });

        print('API Response: $response'); // Debug print

        if (response['status'] == true) {
          final transactionData = response['data'];

          // Refresh user profile to get updated balance
          await _userController.getProfile();

          Get.off(() => TransactionStatusPage(
                status: _getTransactionStatus(transactionData['status']),
                amount: transactionData['amount'],
                reference: transactionData['reference'],
                date: transactionData['transaction_date']['date'],
                recipient: transactionData['phone'],
                network: transactionData['network'].split('-')[0].toUpperCase(),
                productName: transactionData['product_name'],
              ));
        } else {
          throw response['message'] ?? 'Failed to purchase data plan';
        }
      } catch (e) {
        print('API Error: $e'); // Debug print
        // If it's a 400 error, try to get the transaction details
        if (e.toString().contains('400')) {
          final response = await _api.get('bills/status/${serviceId}_$phone');
          if (response['status'] == true && response['data'] != null) {
            final transactionData = response['data'];
            Get.off(() => TransactionStatusPage(
                  status: TransactionStatus.failed,
                  amount: amount,
                  reference: transactionData['reference'] ?? '',
                  date: transactionData['transaction_date']?['date'] ??
                      DateTime.now().toString(),
                  recipient: phone,
                  network: serviceId.split('-')[0].toUpperCase(),
                  productName: 'Data Purchase',
                ));
          } else {
            rethrow;
          }
        } else {
          rethrow;
        }
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

  TransactionStatus _getTransactionStatus(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return TransactionStatus.success;
      case 'failed':
        return TransactionStatus.failed;
      default:
        return TransactionStatus.pending;
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
