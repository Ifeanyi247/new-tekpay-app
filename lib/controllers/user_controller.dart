import 'package:get/get.dart';
import 'package:tekpayapp/controllers/auth_controller.dart';
import 'package:tekpayapp/models/user_model.dart';
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
    final visibility = StorageService.box.read<bool>('balance_visibility') ?? true;
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
      print('Profile Response: $response');

      if (response['data'] != null) {
        print("data: ${response['data']}");
        final userData = response['data'];
        user.value = UserModel.fromJson(userData);
        return response;
      } else {
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
}
