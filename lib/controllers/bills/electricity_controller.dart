import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tekpayapp/services/api_service.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/pages/app/airtime/transaction_status_page.dart';

class ElectricityController extends GetxController {
  final _apiService = Get.find<ApiService>();
  final _userController = Get.find<UserController>();
  final isLoading = false.obs;
  final error = ''.obs;
  final isVerifying = false.obs;
  final verificationError = ''.obs;
  final customerInfo = <String, dynamic>{}.obs;
  final transactionDetails = Rx<Map<String, dynamic>>({});

  Future<void> verifyMeter({
    required String billersCode,
    required String serviceID,
    required String type,
  }) async {
    try {
      isVerifying.value = true;
      verificationError.value = '';
      customerInfo.clear();

      final response = await _apiService.post(
        'bills/electricity/verify',
        body: {
          'billersCode': billersCode,
          'serviceID': serviceID,
          'type': type,
        },
      );

      print('API Response: $response'); // Debug print

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
      print('Error verifying meter: $e');
      verificationError.value = 'An error occurred during verification';
    } finally {
      isVerifying.value = false;
    }
  }

  Future<void> purchaseElectricity({
    required String billersCode,
    required String serviceID,
    required String variationCode,
    required String amount,
    required String phone,
    required String pin,
  }) async {
    try {
      // Validate PIN
      if (pin.isEmpty || pin.length != 4) {
        throw 'Invalid PIN';
      }

      // Validate amount
      final amountValue = double.tryParse(amount);
      if (amountValue == null || amountValue <= 0) {
        throw 'Invalid amount';
      }

      isLoading.value = true;

      try {
        final response = await _apiService.post(
          'bills/electricity/purchase',
          body: {
            'billersCode': billersCode,
            'serviceID': serviceID,
            'variation_code': variationCode,
            'amount': amount,
            'phone': phone,
            'pin': pin,
          },
        );

        if (response['status'] == true) {
          final transactionData = response['data'];

          // Refresh user profile to get updated balance
          await _userController.getProfile();

          Get.off(() => TransactionStatusPage(
                status: _getTransactionStatus(transactionData['status']),
                amount: transactionData['amount'].toString(),
                reference: transactionData['transactionId'],
                date: DateTime.now().toString(),
                recipient: transactionData['unique_element'],
                network: transactionData['product_name'].split('-')[0].trim(),
                productName: transactionData['type'],
              ));
        } else {
          throw response['message'] ?? 'Failed to purchase electricity';
        }
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      print('Error purchasing electricity: $e');
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
      final response = await _apiService.post('bills/status', body: {
        'request_id': requestId,
      });

      if (response['status'] == true && response['data'] != null) {
        final statusData = response['data'];
        final status = statusData['status']?.toString() ?? '';

        // Refresh user profile after getting status
        await _userController.getProfile();

        // If still pending, show pending status with original transaction data
        if (status == 'delivered') {
          transactionDetails.value = {
            "status": true,
            "message": "Electricity purchase successful",
            "data": {
              "status": "delivered",
              "product_name": "Ikeja Electric Payment - PHCN",
              "unique_element": "1010101010101",
              "unit_price": 8000,
              "quantity": 1,
              "service_verification": null,
              "channel": "api",
              "commission": 120,
              "total_amount": 7880,
              "discount": null,
              "type": "Electricity Bill",
              "email": "Oladelep77@gmail.com",
              "phone": "08142403525",
              "name": null,
              "convinience_fee": 0,
              "amount": 8000,
              "platform": "api",
              "method": "api",
              "transactionId": "17370669593125935895265045"
            }
          };
          return;
        }

        // Show final status with updated transaction data
        transactionDetails.value = {
          "status": _getTransactionStatus(status) == TransactionStatus.success,
          "message": _getTransactionStatus(status) == TransactionStatus.success
              ? "Electricity purchase successful"
              : "Electricity purchase failed",
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

  void clearSelection() {
    error.value = '';
    verificationError.value = '';
    customerInfo.clear();
    transactionDetails.value = {};
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
