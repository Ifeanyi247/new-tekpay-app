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

  Future<void> purchaseAirtime({
    required String phone,
    required String amount,
    required String network,
    required String pin,
  }) async {
    try {
      // Validate phone number
      // if (phone.isEmpty || phone.length != 11) {
      //   throw 'Invalid phone number';
      // }

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

          // Refresh user profile to get updated balance
          await _userController.getProfile();

          Get.off(() => TransactionStatusPage(
                status: _getTransactionStatus(transactionData['status']),
                amount: transactionData['amount'],
                reference: transactionData['reference'],
                date: transactionData['transaction_date']['date'],
                recipient: transactionData['phone'],
                network: transactionData['network'],
                productName: transactionData['product_name'],
              ));
        } else {
          throw response['message'] ?? 'Failed to purchase airtime';
        }
      } catch (e) {
        // If it's a 400 error, try to get the transaction details
        if (e.toString().contains('400')) {
          final response = await _api.get('bills/airtime/status/$phone');
          if (response['status'] == true && response['data'] != null) {
            final transactionData = response['data'];
            Get.off(() => TransactionStatusPage(
                  status: TransactionStatus.failed,
                  amount: amount,
                  reference: transactionData['reference'] ?? '',
                  date: transactionData['transaction_date']?['date'] ??
                      DateTime.now().toString(),
                  recipient: phone,
                  network: network,
                  productName: 'Airtime Purchase',
                ));
          } else {
            rethrow;
          }
        } else {
          rethrow;
        }
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
