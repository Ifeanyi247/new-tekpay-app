import 'package:get/get.dart';
import 'package:tekpayapp/services/storage_service.dart';

class AuthService extends GetxService {
  final isSignedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkAuthStatus();
  }

  void checkAuthStatus() {
    final token = StorageService.getToken();
    isSignedIn.value = token != null;
  }

  Future<void> signOut() async {
    await StorageService.removeToken();
    isSignedIn.value = false;
  }
}
