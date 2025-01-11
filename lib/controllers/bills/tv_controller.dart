import 'package:get/get.dart';
import 'package:tekpayapp/services/api_service.dart';

class TvController extends GetxController {
  final _apiService = Get.find<ApiService>();

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<Map<String, dynamic>> tvPlans = <Map<String, dynamic>>[].obs;
  final RxString selectedPlan = ''.obs;
  final RxString selectedAmount = ''.obs;
  final RxBool isVerifying = false.obs;
  final RxString verificationError = ''.obs;
  final RxMap<String, dynamic> customerInfo = <String, dynamic>{}.obs;
  final RxBool isSubscribing = false.obs;
  final RxString subscriptionError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    ever(customerInfo, (_) => update());
  }

  Future<Map<String, dynamic>?> fetchTvPlans(String serviceID) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await _apiService.get('bills/tv/plans/$serviceID');

      if (response['status'] == true) {
        final variations =
            List<Map<String, dynamic>>.from(response['data']['varations']);
        tvPlans.assignAll(variations);
        return response;
      } else {
        error.value = response['message'] ?? 'Failed to fetch TV plans';
        return null;
      }
    } catch (e) {
      error.value = e.toString();
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> verifySmartCard(String cardNumber, String provider) async {
    try {
      isVerifying.value = true;
      error.value = '';
      customerInfo.clear();

      final response = await _apiService.post(
        'bills/tv/verify-smartcard',
        body: {
          'billersCode': cardNumber,
          'serviceID': provider.toLowerCase(),
        },
      );

      print('Verification Response: $response'); // Debug print

      if (response['status'] == true) {
        final data = response['data'];
        print('Customer Info: $data'); // Debug print
        customerInfo.value = Map<String, dynamic>.from(data);
        return true;
      } else {
        error.value = response['message'] ?? 'Failed to verify smart card';
        return false;
      }
    } catch (e) {
      print('Verification Error: $e'); // Debug print
      error.value = 'Failed to verify smart card';
      return false;
    } finally {
      isVerifying.value = false;
    }
  }

  void selectPlan(Map<String, dynamic> plan) {
    selectedPlan.value = plan['name'];
    selectedAmount.value = plan['variation_amount'];
  }

  void clearSelection() {
    selectedPlan.value = '';
    selectedAmount.value = '';
    error.value = '';
    verificationError.value = '';
    customerInfo.clear();
  }

  Future<bool> subscribeTv({
    required String billersCode,
    required String serviceID,
    required String amount,
    required String phone,
    required String subscriptionType,
    required String variationCode,
  }) async {
    try {
      isSubscribing.value = true;
      subscriptionError.value = '';

      final response = await _apiService.post(
        'bills/tv/subscribe',
        body: {
          'billersCode': billersCode,
          'serviceID': serviceID,
          'amount': amount,
          'phone': phone,
          'subscription_type': subscriptionType,
          'variation_code': variationCode,
        },
      );

      if (response['status'] == true) {
        return true;
      } else {
        subscriptionError.value = response['message'] ?? 'Failed to subscribe';
        return false;
      }
    } catch (e) {
      subscriptionError.value = 'An error occurred while subscribing';
      return false;
    } finally {
      isSubscribing.value = false;
    }
  }
}
