import 'package:get/get.dart';
import 'package:tekpayapp/models/user_model.dart';
import 'package:tekpayapp/services/api_service.dart';
import 'package:tekpayapp/services/api_exception.dart';
import 'package:tekpayapp/services/storage_service.dart';

class UserController extends GetxController {
  final isLoading = true.obs;
  final user = Rxn<UserModel>();
  final error = Rxn<String>();
  final isBalanceVisible = true.obs;

  final _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    final token = StorageService.getToken();
    if (token != null) {
      _apiService.setAuthToken(token);
    }
    _loadBalanceVisibility();
    getProfile();
  }

  void _loadBalanceVisibility() {
    final visibility = StorageService.box.read<bool>('balance_visibility') ?? true;
    isBalanceVisible.value = visibility;
  }

  void toggleBalanceVisibility() {
    isBalanceVisible.value = !isBalanceVisible.value;
    StorageService.box.write('balance_visibility', isBalanceVisible.value);
  }

  Future<void> getProfile() async {
    try {
      isLoading.value = true;
      error.value = null;

      final token = StorageService.getToken();
      if (token == null) {
        error.value = 'Authentication token not found';
        return;
      }

      // Add a 2-second delay to simulate network latency
      await Future.delayed(const Duration(seconds: 2));

      final response = await _apiService.get('user');
      if (response['data'] != null) {
        user.value = UserModel.fromJson(response['data']);
      } else {
        error.value = 'Invalid response format';
      }
    } on ApiException catch (e) {
      print('API Error: ${e.message}');
      if (e.statusCode == 401) {
        error.value = 'Session expired. Please login again';
        // You might want to handle token expiration here
        // For example: Get.offAll(() => LoginPage());
      } else {
        error.value = e.message;
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      error.value = 'An error occurred while loading your profile';
    } finally {
      isLoading.value = false;
    }
  }

  void clearError() {
    error.value = null;
  }
}
