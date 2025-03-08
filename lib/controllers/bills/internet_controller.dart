import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/services/api_service.dart';
import 'package:tekpayapp/services/api_exception.dart';

class InternetController extends GetxController {
  final _api = ApiService();
  final _userController = Get.find<UserController>();
  final variations = RxList<Map<String, dynamic>>([]);
  final error = ''.obs;
  final customerName = ''.obs;
  final accountList = RxList<Map<String, dynamic>>([]);
  final isLoading = false.obs;

  Future<void> fetchInternetPlans() async {
    try {
      error.value = '';

      final response = await _api.get('bills/internet/variations/smile-direct');

      if (response['status'] == true) {
        variations.value =
            List<Map<String, dynamic>>.from(response['data']['variations']);
      } else {
        error.value = response['message'] ?? 'Failed to fetch internet plans';
        Get.snackbar(
          'Error',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error fetching internet plans: $e');
      Get.snackbar(
        'Error',
        'An error occurred',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<bool> verifyEmail(String email) async {
    try {
      error.value = '';

      final response = await _api.post(
        'bills/internet/verify-email',
        body: {
          'billersCode': email,
          'serviceID': 'smile-direct',
        },
      );

      if (response['status'] == true) {
        final data = response['data'];
        customerName.value = data['Customer_Name'];
        if (data['AccountList'] != null &&
            data['AccountList']['Account'] != null) {
          accountList.value =
              List<Map<String, dynamic>>.from(data['AccountList']['Account']);
        }
        return true;
      } else {
        error.value = response['message'] ?? 'Failed to verify email';
        Get.snackbar(
          'Error',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('Error verifying email: $e');
      Get.snackbar(
        'Error',
        'An error occurred while verifying email',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<Map<String, dynamic>?> purchaseInternet({
    required String phone,
    required String variationCode,
    required String amount,
    required String billersCode,
    required String pin,
  }) async {
    try {
      isLoading.value = true;
      
      // Validate PIN with user profile
      final userModel = _userController.user.value;
      if (userModel == null || userModel.profile.pinCode != int.parse(pin)) {
        error.value = 'Invalid PIN';
        Get.snackbar(
          'Error',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return null;
      }

      final response = await _api.post(
        'bills/internet/purchase',
        body: {
          'phone': phone,
          'serviceID': 'smile-direct',
          'variation_code': variationCode,
          'amount': amount,
          'billersCode': billersCode,
        },
      );

      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          'Internet purchase successful',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return {
          'reference': response['data']['reference'] ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          'date': DateTime.now().toString(),
        };
      } else {
        error.value = response['message'] ?? 'Failed to purchase internet';
        Get.snackbar(
          'Error',
          error.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return null;
      }
    } catch (e) {
      print('Error purchasing internet: $e');
      Get.snackbar(
        'Error',
        'An error occurred while processing your purchase',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchInternetPlans();
  }
}
