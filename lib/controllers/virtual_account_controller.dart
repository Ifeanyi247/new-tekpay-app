import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/pages/app/airtime/transaction_status_page.dart';
import 'package:tekpayapp/services/api_service.dart';
import 'package:tekpayapp/services/api_exception.dart';
import 'package:tekpayapp/models/transfer_response.dart';

class VirtualAccountController extends GetxController {
  final _api = ApiService();
  final isLoading = false.obs;
  final virtualAccountDetails = Rxn<Map<String, dynamic>>();
  final error = ''.obs;

  Future<Map<String, dynamic>?> createVirtualAccount(amount) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await _api.post(
        'flutterwave/virtual-account/create',
        body: {
          'amount': amount,
        },
      );

      if (response['status'] == 'success') {
        virtualAccountDetails.value = response['data'];
        return response;
      } else {
        throw ApiException(
          statusCode: 0,
          message: response['message'] ?? 'Failed to create virtual account',
        );
      }
    } on ApiException catch (e) {
      error.value = e.message;
      Get.snackbar(
        'Error',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    } catch (e) {
      error.value = 'An unexpected error occurred';
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> initiateTransfer({
    required String accountNumber,
    required String accountBank,
    required String accoutName,
    required double amount,
    String? narration,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await _api.post(
        'flutterwave/transfer',
        body: {
          'account_number': accountNumber,
          'account_bank': accountBank,
          'account_name': accoutName,
          'amount': amount,
          if (narration != null) 'narration': narration,
        },
      );

      print(accountBank);

      final transferResponse = TransferResponse.fromJson(response);

      final now = DateTime.now();

      // get user data
      final userController = Get.find<UserController>();
      userController.getProfile();

      // Navigate to transaction status page
      Get.off(() => TransactionStatusPage(
            status: transferResponse.status == 'success'
                ? TransactionStatus.success
                : TransactionStatus.failed,
            amount: 'NGN ${amount.toStringAsFixed(2)}',
            reference: transferResponse.data.reference,
            date: now.toString(),
            recipient: transferResponse.data.transferDetails.fullName,
            network: transferResponse.data.transferDetails.bankName,
            productName:
                'Bank Transfer - ${transferResponse.data.transferDetails.fullName}',
          ));
    } catch (e) {
      error.value = e.toString();
      print('Error initiating transfer: $e');

      // Navigate to transaction status page with error
      Get.snackbar('Error', 'An unexpected error occurred');
      Get.off(() => TransactionStatusPage(
            status: TransactionStatus.failed,
            amount: 'NGN ${amount.toStringAsFixed(2)}',
            reference: '',
            date: DateTime.now().toString(),
            recipient: '',
            network: '',
            productName: 'Bank Transfer',
          ));
    } finally {
      isLoading.value = false;
    }
  }

  void clearVirtualAccount() {
    virtualAccountDetails.value = null;
    error.value = '';
  }
}
