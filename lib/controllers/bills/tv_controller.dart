import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/pages/app/airtime/transaction_status_page.dart';
import 'package:tekpayapp/services/api_service.dart';

class TvController extends GetxController {
  final _apiService = Get.find<ApiService>();
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<Map<String, dynamic>> tvPlans = <Map<String, dynamic>>[].obs;
  final RxString selectedPlan = ''.obs;
  final RxString selectedAmount = ''.obs;
  final RxBool isVerifying = false.obs;
  final RxString verificationError = ''.obs;
  final RxMap<String, dynamic> customerInfo = <String, dynamic>{}.obs;
  final RxBool isSubscribing = false.obs;
  final RxString subscriptionError = ''.obs;
  final Rx<Map<String, dynamic>> transactionDetails =
      Rx<Map<String, dynamic>>({});

  @override
  void onInit() {
    super.onInit();
  }

  Future<Map<String, dynamic>?> fetchTvPlans(String serviceID) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await _apiService.get('bills/tv/variations/$serviceID');

      if (response['status'] == true) {
        final variations =
            List<Map<String, dynamic>>.from(response['data']['varations']);
        tvPlans.assignAll(variations);
        return response;
      } else {
        error.value = response['message'] ?? 'Failed to fetch TV plans';
        return null;
      }
    } catch (e) {
      error.value = e.toString();
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifySmartCard(String cardNumber, String provider) async {
    try {
      isVerifying.value = true;
      verificationError.value = '';
      customerInfo.clear();

      final response = await _apiService.post(
        'bills/tv/verify',
        body: {
          'billersCode': cardNumber,
          'serviceID': provider,
        },
      );

      if (response['status'] == true) {
        final data = response['data'];
        if (data is Map<String, dynamic> && data.containsKey('error')) {
          verificationError.value = data['error'];
        } else {
          customerInfo.value = Map<String, dynamic>.from(data);
        }
      } else {
        verificationError.value = response['message'] ?? 'Verification failed';
      }
    } catch (e) {
      verificationError.value = 'An error occurred during verification';
    } finally {
      isVerifying.value = false;
    }
  }

  void selectPlan(Map<String, dynamic> plan) {
    selectedPlan.value = plan['name'];
    selectedAmount.value = plan['variation_amount'];
  }

  void clearSelection() {
    selectedPlan.value = '';
    selectedAmount.value = '';
    error.value = '';
    verificationError.value = '';
    customerInfo.clear();
    transactionDetails.value = {};
  }

  Future<void> subscribeTv({
    required String billersCode,
    required String serviceID,
    required String amount,
    required String phone,
    required String subscriptionType,
    required String variationCode,
    required String pin,
  }) async {
    try {
      // Validate PIN
      if (pin.isEmpty || pin.length != 4) {
        throw 'Invalid PIN';
      }

      // Verify PIN with user profile
      final userModel = Get.find<UserController>().user.value;
      if (userModel == null || userModel.profile.pinCode.toString() != pin) {
        throw 'Invalid transaction PIN';
      }

      isSubscribing.value = true;
      subscriptionError.value = '';

      final response = await _apiService.post(
        'bills/tv/purchase',
        body: {
          'billersCode': billersCode,
          'serviceID': serviceID,
          'amount': amount,
          'phone': phone,
          'subscription_type': subscriptionType,
          'variation_code': variationCode,
          'pin': pin,
        },
      );

      print('API Response: $response'); // Debug print

      if (response['status'] == true) {
        final transactionData = response['data'];
        transactionDetails.value = Map<String, dynamic>.from(transactionData);

        // Refresh user profile to get updated balance
        final userController = Get.find<UserController>();
        await userController.getProfile();

        Get.off(() => TransactionStatusPage(
              status:
                  _getTransactionStatus(transactionData['status'] ?? 'failed'),
              amount: transactionData['amount']?.toString() ?? amount,
              reference: transactionData['transactionId'] ?? '',
              recipient: billersCode,
              network: serviceID.split('-')[0].toUpperCase(),
              productName: transactionData['product_name'] ?? 'TV Subscription',
              date: DateTime.now().toString(),
            ));
      } else {
        throw response['message'] ?? 'Failed to subscribe';
      }
    } catch (e) {
      print('Error subscribing to TV: $e');
      Get.back(); // Close pin dialog
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubscribing.value = false;
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
      final response = await _apiService.post('bills/status', body: {
        'request_id': requestId,
      });

      if (response['status'] == true && response['data'] != null) {
        final statusData = response['data'];
        final status = statusData['status']?.toString() ?? '';

        // Refresh user profile after getting status
        await Get.find<UserController>().getProfile();

        // If still pending, show pending status with original transaction data
        if (status == 'pending') {
          transactionDetails.value = {
            "status": true,
            "message": "TV subscription successful",
            "data": {
              "status": "pending",
              "product_name": "Startimes Subscription",
              "unique_element": "201000000000",
              "unit_price": 1400,
              "quantity": 1,
              "service_verification": null,
              "channel": "api",
              "commission": 35,
              "total_amount": 1365,
              "discount": null,
              "type": "TV Subscription",
              "email": "Oladelep77@gmail.com",
              "phone": "08142403525",
              "name": null,
              "convinience_fee": 0,
              "amount": 1400,
              "platform": "api",
              "method": "api",
              "transactionId": "17370654002724410119528661"
            }
          };
          return;
        }

        // Show final status with updated transaction data
        transactionDetails.value = {
          "status": _getTransactionStatus(status) == TransactionStatus.success,
          "message": _getTransactionStatus(status) == TransactionStatus.success
              ? "TV subscription successful"
              : "TV subscription failed",
          "data": {
            "status": status,
            "product_name": statusData['product_name'] ?? productName,
            "unique_element": statusData['unique_element'] ?? "",
            "unit_price": statusData['unit_price'] ?? 0,
            "quantity": statusData['quantity'] ?? 0,
            "service_verification": statusData['service_verification'],
            "channel": statusData['channel'] ?? "",
            "commission": statusData['commission'] ?? 0,
            "total_amount": statusData['total_amount'] ?? 0,
            "discount": statusData['discount'],
            "type": statusData['type'] ?? "",
            "email": statusData['email'] ?? "",
            "phone": statusData['phone'] ?? phone,
            "name": statusData['name'],
            "convinience_fee": statusData['convinience_fee'] ?? 0,
            "amount": statusData['amount'] ?? amount,
            "platform": statusData['platform'] ?? "",
            "method": statusData['method'] ?? "",
            "transactionId": statusData['transactionId'] ?? reference
          }
        };
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
      case 'successful':
        return TransactionStatus.success;
      case 'failed':
        return TransactionStatus.failed;
      default:
        return TransactionStatus.pending;
    }
  }
}
