import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/models/user_model.dart';
import 'package:tekpayapp/pages/auth/security_pin_page.dart';
import 'package:tekpayapp/pages/widgets/bottom_bar.dart';
import 'package:tekpayapp/services/api_service.dart';
import 'package:tekpayapp/pages/auth/otp_verification_page.dart';
import 'package:tekpayapp/services/api_exception.dart';
import 'package:tekpayapp/services/storage_service.dart';

class AuthController extends GetxController {
  final _api = ApiService();
  final isLoading = false.obs;
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);

  Future<void> register({
    required String username,
    required String firstName,
    required String lastName,
    required String email,
    required String phoneNumber,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      isLoading.value = true;
      final response = await _api.post('auth/register', body: {
        'username': username,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone_number': phoneNumber,
        'password': password,
        'confirm_password': confirmPassword,
      });

      if (response['status'] == true) {
        Get.snackbar(
          'Success',
          response['message'] ?? 'OTP has been sent to your email',
          backgroundColor: primaryColor,
          colorText: Colors.white,
        );
        print(response);
        Get.to(() => OtpVerificationPage(email: email));
      } else {
        final message = response['message'] ?? 'Registration failed';
        Get.snackbar(
          'Error',
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      }
    } on ApiException catch (e) {
      if (e.statusCode == 422) {
        Get.snackbar(
          'Validation Error',
          e.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      } else {
        Get.snackbar(
          'Error',
          e.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      isLoading.value = true;
      final response = await _api.post('auth/verify-otp', body: {
        'email': email,
        'otp': otp,
      });

      if (response['status'] == true) {
        final pinToken = response['pin_token'];
        Get.snackbar(
          'Success',
          response['message'] ?? 'OTP verified successfully',
          backgroundColor: primaryColor,
          colorText: Colors.white,
        );
        Get.to(() => SecurityPinPage(pinToken: pinToken, email: email));
      }
    } on ApiException catch (e) {
      Get.snackbar(
        'Error',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createPin({
    required String pinToken,
    required String pinCode,
    required String pinCodeConfirmation,
  }) async {
    try {
      isLoading.value = true;
      final response = await _api.post('auth/create-pin', body: {
        'pin_token': pinToken,
        'pin_code': pinCode,
        'pin_code_confirmation': pinCodeConfirmation,
      });

      if (response['status'] == true) {
        // Set user data
        final userData = response['data']['user'];
        currentUser.value = UserModel.fromJson(userData);

        // Set auth token
        final token = response['data']['token'];
        await StorageService.setToken(token);
        _api.setAuthToken(token);

        Get.snackbar(
          'Success',
          response['message'] ?? 'Registration completed successfully',
          backgroundColor: primaryColor,
          colorText: Colors.white,
        );

        // Navigate to home page
        Get.offAll(() => const BottomBar());
      }
    } on ApiException catch (e) {
      Get.snackbar(
        'Error',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
