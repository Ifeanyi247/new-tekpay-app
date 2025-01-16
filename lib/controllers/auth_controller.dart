import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/constants/colors.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/models/user_model.dart';
import 'package:tekpayapp/pages/auth/otp_verification_page.dart';
import 'package:tekpayapp/pages/auth/register_page.dart';
import 'package:tekpayapp/pages/auth/security_pin_page.dart';
import 'package:tekpayapp/pages/welcome_screen.dart';
import 'package:tekpayapp/pages/widgets/bottom_bar.dart';
import 'package:tekpayapp/services/api_service.dart';
import 'package:tekpayapp/services/api_exception.dart';
import 'package:tekpayapp/services/storage_service.dart';

class AuthController extends GetxController {
  // Share the API instance
  static final _api = ApiService();
  ApiService get api => _api;

  final isLoading = false.obs;
  final error = Rxn<String>();
  final currentUser = Rxn<UserModel>();
  final loginToken = ''.obs;
  final tempUserName = ''.obs;
  final tempUserImage = ''.obs;

  void navigateToRegister() {
    // Clear all user data before showing register page
    currentUser.value = null;
    final userController = Get.find<UserController>();
    userController.clearUserData();
    Get.to(() => const RegisterPage());
  }

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
      // Clear any existing user data before registration
      currentUser.value = null;
      final userController = Get.find<UserController>();
      userController.clearUserData();

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
      print(e.toString());
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
        // Store the token and fetch profile after PIN creation
        final token = response['data']['token'];
        await StorageService.setToken(token);
        _api.setAuthToken(token);

        // Get user profile
        final userController = Get.find<UserController>();
        await userController.getProfile();

        final userData = response['data']['user'];
        currentUser.value = UserModel.fromJson(userData);

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

  Future<bool> login(String username, String password) async {
    try {
      isLoading.value = true;
      error.value = null;

      final response = await _api.post('auth/login', body: {
        'username': username,
        'password': password,
      });

      if (response['status'] == true) {
        print(response);
        loginToken.value = response['login_token'];
        tempUserName.value = response['username'] ?? '';
        tempUserImage.value = response['profile_url'] ?? '';
        return true;
      }

      if (response['errors'] != null) {
        final errors = response['errors'] as Map<String, dynamic>;
        if (errors.isNotEmpty) {
          error.value = errors.values.first[0];
          return false;
        }
      }

      error.value = response['message'] ?? 'Login failed';
      return false;
    } on ApiException catch (e) {
      error.value = e.message;
      return false;
    } catch (e) {
      print('Login error: $e');
      error.value = 'An error occurred during login';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> verifyPin(String pin) async {
    try {
      isLoading.value = true;
      error.value = null;

      print('Verifying PIN with login token: ${loginToken.value}');

      final response = await _api.post('auth/verify-pin', body: {
        'login_token': loginToken.value,
        'pin_code': pin.toString(),
      });

      print('Verify PIN Response: $response');

      if (response['status'] == true && response['data'] != null) {
        print("From verify: ${response['data']['token']}");
        // Clear old token and user data first
        final userController = Get.find<UserController>();
        userController.clearUserData();

        // Set new token
        final token = response['data']['token'];
        print('verify token: $token');
        await StorageService.setToken(token);
        _api.setAuthToken(token);

        try {
          // The user data already contains the nested profile
          final userData = response['data']['user'];
          currentUser.value = UserModel.fromJson(userData);
          userController.user.value = UserModel.fromJson(userData);
          loginToken.value = ''; // Clear login token after successful verification
          return true;
        } catch (e, stack) {
          print('Error parsing user data: $e');
          print('Stack trace: $stack');
          error.value = 'Error parsing user data';
          return false;
        }
      }

      if (response['errors'] != null) {
        final errors = response['errors'] as Map<String, dynamic>;
        if (errors.isNotEmpty) {
          error.value = errors.values.first[0];
        }
      }
      return false;
    } on ApiException catch (e) {
      error.value = e.message;
      return false;
    } catch (e) {
      print('PIN verification error: $e');
      error.value = 'An error occurred during PIN verification';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      final response = await _api.post('auth/logout');

      if (response['status'] == true) {
        // Clear user data
        currentUser.value = null;
        final userController = Get.find<UserController>();
        userController.clearUserData();

        // Clear API token
        _api.setAuthToken('');

        Get.snackbar(
          'Success',
          response['message'] ?? 'Logged out successfully',
          backgroundColor: primaryColor,
          colorText: Colors.white,
        );

        // Navigate to welcome screen
        Get.offAll(() => const WelcomeScreen());
      }
    } catch (e) {
      print('Logout error: $e');
      // Clear data even if API call fails
      currentUser.value = null;
      final userController = Get.find<UserController>();
      userController.clearUserData();
      _api.setAuthToken('');
      Get.offAll(() => const WelcomeScreen());
    } finally {
      isLoading.value = false;
    }
  }

  void clearError() {
    error.value = null;
  }
}
