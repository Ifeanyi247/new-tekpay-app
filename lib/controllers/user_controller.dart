import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/controllers/auth_controller.dart';
import 'package:tekpayapp/models/user_model.dart';
import 'package:tekpayapp/models/transfer_model.dart';
import 'package:tekpayapp/pages/auth/login_page.dart';
import 'package:tekpayapp/services/api_service.dart';
import 'package:tekpayapp/services/api_exception.dart';
import 'package:tekpayapp/services/storage_service.dart';

class UserController extends GetxController {
  late final AuthController _authController;
  late final ApiService _apiService;

  final isLoading = false.obs;
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final error = Rxn<String>();
  final isBalanceVisible = true.obs;
  final isResendingOtp = false.obs;
  final transfers = <TransferModel>[].obs;
  final isLoadingTransfers = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeController();
  }

  void _initializeController() {
    _authController = Get.find<AuthController>();
    _apiService = _authController.api;
    _loadBalanceVisibility();

    final token = StorageService.getToken();
    if (token != null) {
      _apiService.setAuthToken(token);
      getProfile();
    }
  }

  void _loadBalanceVisibility() {
    final visibility =
        StorageService.box.read<bool>('balance_visibility') ?? true;
    isBalanceVisible.value = visibility;
  }

  void toggleBalanceVisibility() {
    isBalanceVisible.value = !isBalanceVisible.value;
    StorageService.box.write('balance_visibility', isBalanceVisible.value);
  }

  void clearUserData() {
    user.value = null;
    error.value = null;
    isLoading.value = false;
    StorageService.box.remove('user_data');
    StorageService.removeToken();
    _apiService.removeAuthToken();
  }

  Future<dynamic> getProfile() async {
    try {
      // Check if token exists first
      final token = StorageService.getToken();
      if (token == null) {
        clearUserData();
        return;
      }

      print('Token for profile fetch: $token');

      // Ensure API service has the latest token
      _apiService.setAuthToken(token);

      isLoading.value = true;
      error.value = null;

      final response = await _apiService.get('user');
      print('Full Profile Response: $response');

      if (response['status'] == true && response['data'] != null) {
        final responseData = response['data'];
        print('Full User Data Structure: $responseData');

        // Log the type of userData
        print('User Data Type: ${responseData.runtimeType}');

        // Log all keys in userData
        if (responseData is Map) {
          print(
              'Available keys in responseData: ${responseData.keys.toList()}');
        }

        // Extract user data from nested structure
        final userData = responseData['user'] as Map<String, dynamic>;
        // The profile is already in the correct place
        userData['profile'] = responseData['profile'];

        print('Processed User Data: $userData');

        try {
          user.value = UserModel.fromJson(userData);
          return response;
        } catch (e, stackTrace) {
          print('Error parsing user data: $e');
          print('Stack trace: $stackTrace');
          throw 'Error parsing user data: $e';
        }
      } else {
        print(
            'Invalid response structure. Status: ${response['status']}, Has data: ${response['data'] != null}');
        clearUserData();
        error.value = 'Invalid response format';
      }
    } on ApiException catch (e) {
      print('API Error: ${e.message}');
      if (e.statusCode == 401) {
        clearUserData();
        error.value = 'Session expired. Please login again';
        Get.offAll(() => const LoginPage());
      } else {
        error.value = e.message;
      }
    } catch (e) {
      print('Error getting profile: $e');
      clearUserData();
    } finally {
      isLoading.value = false;
    }
  }

  void clearError() {
    error.value = null;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      isLoading.value = true;
      error.value = null;

      final response = await _apiService.post(
        'user/change-password',
        body: {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': confirmPassword,
        },
      );

      if (response['status'] == true) {
        Get.back();
        Get.snackbar(
          'Success',
          response['message'] ?? 'Password changed successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on ApiException catch (e) {
      error.value = e.message;
      Get.snackbar(
        'Error',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendPinChangeOtp({
    required String email,
  }) async {
    try {
      isLoading.value = true;
      error.value = null;

      final response = await _apiService.post(
        'user/send-pin-change-otp',
        body: {
          'email': email,
        },
      );

      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'] ?? 'OTP sent successfully',
          backgroundColor: primaryColor,
          colorText: Colors.white,
        );
      }
    } on ApiException catch (e) {
      error.value = e.message;
      Get.snackbar(
        'Error',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> resendPinChangeOtp({
    required String email,
  }) async {
    try {
      isLoading.value = true;
      error.value = null;

      final response = await _apiService.post(
        'user/resend-pin-change-otp',
        body: {
          'email': email,
        },
      );

      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'] ?? 'New OTP has been sent to your email',
          backgroundColor: primaryColor,
          colorText: Colors.white,
        );
        return true;
      }
      return false;
    } on ApiException catch (e) {
      error.value = e.message;
      Get.snackbar(
        'Error',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> verifyPinChangeOtp({required String otp}) async {
    try {
      isLoading.value = true;
      error.value = null;

      final response = await _apiService.post(
        'user/verify-pin-change-otp',
        body: {
          'otp': otp,
        },
      );

      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'] ?? 'OTP verified successfully',
          backgroundColor: primaryColor,
          colorText: Colors.white,
        );
        return response['data']['pin_token'];
      }
      error.value = response['message'];
      Get.snackbar(
        'Error',
        response['message'] ?? 'Failed to verify OTP',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    } on ApiException catch (e) {
      error.value = e.message;
      Get.snackbar(
        'Error',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> changeTransactionPin({
    required String pin,
    required String pinToken,
  }) async {
    try {
      isLoading.value = true;
      error.value = null;

      final response = await _apiService.post(
        'user/change-transaction-pin',
        body: {
          'new_pin': pin,
          'pin_token': pinToken,
        },
      );

      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'] ?? 'Transaction PIN changed successfully',
          backgroundColor: primaryColor,
          colorText: Colors.white,
        );
        await getProfile();
        return true;
      }
      error.value = response['message'];
      Get.snackbar(
        'Error',
        response['message'] ?? 'Failed to change transaction PIN',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } on ApiException catch (e) {
      error.value = e.message;
      Get.snackbar(
        'Error',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> changeTransactionPinNoAuth({
    required String pin,
    required String pinToken,
  }) async {
    try {
      isLoading.value = true;
      error.value = null;

      final response = await _apiService.post(
        'change-transaction-pin',
        body: {
          'new_pin': pin,
          'pin_token': pinToken,
        },
      );

      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'] ?? 'Transaction PIN changed successfully',
          backgroundColor: primaryColor,
          colorText: Colors.white,
        );
        await getProfile();
        return true;
      }
      error.value = response['message'];
      Get.snackbar(
        'Error',
        response['message'] ?? 'Failed to change transaction PIN',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } on ApiException catch (e) {
      error.value = e.message;
      Get.snackbar(
        'Error',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserTransfers() async {
    try {
      isLoadingTransfers.value = true;
      final response = await _apiService.get('user/transfers');

      if (response['status'] == true) {
        final List<dynamic> transfersData = response['data'];
        transfers.value = transfersData
            .map((transfer) => TransferModel.fromJson(transfer))
            .toList();
      } else {
        throw response['message'] ?? 'Failed to fetch transfers';
      }
    } catch (e) {
      print('Error fetching transfers: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch transfers',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingTransfers.value = false;
    }
  }

  Future<Map<String, dynamic>> getReferrals() async {
    try {
      isLoading.value = true;
      error.value = null;

      final response = await _apiService.get('user/referrals');

      if (response['status'] == true) {
        return response;
      } else {
        error.value = response['message'] ?? 'Failed to fetch referral data';
        throw ApiException(statusCode: 500, message: error.value!);
      }
    } on ApiException catch (e) {
      error.value = e.message;
      Get.snackbar(
        'Error',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    } catch (e) {
      error.value = 'An unexpected error occurred';
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
}
