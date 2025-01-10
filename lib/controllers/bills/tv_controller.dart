import 'package:get/get.dart';
import 'package:tekpayapp/services/api_service.dart';

class TvController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<Map<String, dynamic>> tvPlans = <Map<String, dynamic>>[].obs;
  final RxString selectedPlan = ''.obs;
  final RxString selectedAmount = ''.obs;
  final RxBool isVerifying = false.obs;
  final RxString verificationError = ''.obs;
  final RxMap<String, dynamic> customerInfo = <String, dynamic>{}.obs;

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

  Future<bool> verifySmartCard(String billersCode, String serviceID) async {
    try {
      isVerifying.value = true;
      verificationError.value = '';
      customerInfo.clear();

      final response = await _apiService.post(
        'bills/tv/verify-smartcard',
        body: {
          'billersCode': billersCode,
          'serviceID': serviceID,
        },
      );

      if (response['status'] == true) {
        customerInfo.assignAll(response['data'] ?? {});
        return true;
      } else {
        verificationError.value =
            response['message'] ?? 'Failed to verify smart card';
        return false;
      }
    } catch (e) {
      verificationError.value = e.toString();
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
}
