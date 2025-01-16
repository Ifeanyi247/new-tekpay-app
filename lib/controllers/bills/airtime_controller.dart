import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/services/api_service.dart';
import 'package:tekpayapp/pages/app/airtime/transaction_status_page.dart';
import 'package:tekpayapp/controllers/user_controller.dart';

class AirtimeWorkingController extends GetxController {
  final _api = ApiService();
  final _userController = Get.find<UserController>();
  final isLoading = false.obs;
  final savedBeneficiaries = <Map<String, String>>[].obs;

  final serviceIds = {
    'MTN': 'mtn',
    'GLO': 'glo',
    'Airtel': 'airtel',
    '9Mobile': '9mobile',
  };

  Future<void> purchaseAirtime({
    required String phone,
    required String amount,
    required String network,
    required String pin,
  }) async {
    try {
      // Validate amount
      final amountValue = double.tryParse(amount);
      if (amountValue == null || amountValue < 50) {
        throw 'Invalid amount';
      }

      // Validate network
      if (!serviceIds.containsKey(network)) {
        throw 'Invalid network selected';
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
        final response = await _api.post('bills/airtime', body: {
          'phone': phone,
          'amount': amount,
          'serviceID': serviceIds[network],
          'pin': pin,
        });

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
                network: transactionData['network'],
                productName: transactionData['product_name'],
              ));
        } else {
          throw response['message'] ?? 'Failed to purchase airtime';
        }
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      print('Error purchasing airtime: $e');
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
                network: network,
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
              network: statusData['network'] ?? network,
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
    switch (status) {
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

  void addBeneficiary(String name, String number) {
    savedBeneficiaries.add({
      'name': name,
      'number': number,
    });
  }

  void removeBeneficiary(int index) {
    savedBeneficiaries.removeAt(index);
  }
}
