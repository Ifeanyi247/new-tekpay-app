import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/services/api_service.dart';
import 'package:tekpayapp/services/api_exception.dart';

class VirtualAccountController extends GetxController {
  final _api = ApiService();
  final isLoading = false.obs;
  final virtualAccountDetails = Rxn<Map<String, dynamic>>();
  final error = ''.obs;

  Future<Map<String, dynamic>?> createVirtualAccount() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await _api.post(
        'flutterwave/virtual-account/create',
        body: {},
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
}
