import 'package:get/get.dart';
import 'package:tekpayapp/models/bank_model.dart';
import 'package:tekpayapp/models/account_verify_response.dart';
import 'package:tekpayapp/services/api_service.dart';

class TransferController extends GetxController {
  final _apiService = Get.find<ApiService>();
  final banks = Rxn<BankResponse>();
  final isLoading = false.obs;
  final error = ''.obs;

  // Account verification observables
  final verificationLoading = false.obs;
  final verificationError = ''.obs;
  final accountDetails = Rxn<AccountData>();

  Future<void> fetchBanks() async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await _apiService.get('flutterwave/banks/nigeria');
      banks.value = BankResponse.fromJson(response);
    } catch (e) {
      error.value = e.toString();
      print('Error fetching banks: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyAccount({
    required String accountNumber,
    required String bankCode,
  }) async {
    try {
      verificationLoading.value = true;
      verificationError.value = '';
      accountDetails.value = null;

      final response = await _apiService.post(
        'flutterwave/bank/verify-account',
        body: {
          'account_number': accountNumber,
          'account_bank': bankCode,
        },
      );

      final verifyResponse = AccountVerifyResponse.fromJson(response);
      accountDetails.value = verifyResponse.data;
    } catch (e) {
      verificationError.value = e.toString();
      print('Error verifying account: $e');
    } finally {
      verificationLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchBanks();
  }
}
