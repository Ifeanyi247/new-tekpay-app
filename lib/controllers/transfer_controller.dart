import 'package:get/get.dart';
import 'package:tekpayapp/controllers/user_controller.dart';
import 'package:tekpayapp/models/bank_model.dart';
import 'package:tekpayapp/models/account_verify_response.dart';
import 'package:tekpayapp/models/transfer_response.dart';
import 'package:tekpayapp/pages/app/airtime/transaction_status_page.dart';
import 'package:tekpayapp/pages/widgets/transaction_status_page_in_app.dart';
import 'package:tekpayapp/services/api_service.dart';

class TransferController extends GetxController {
  final _apiService = Get.find<ApiService>();
  final banks = Rxn<BankResponse>();
  final isLoading = false.obs;
  final error = ''.obs;
  final amount = 0.0.obs;

  // Account verification observables
  final verificationLoading = false.obs;
  final verificationError = ''.obs;
  final accountDetails = Rxn<AccountData>();

  // User search observables
  final userSearchLoading = false.obs;
  final userSearchError = ''.obs;
  final userSearchResult = Rxn<Map<String, dynamic>>();

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

  Future<String?> searchUser(String query) async {
    try {
      userSearchLoading.value = true;
      userSearchError.value = '';
      userSearchResult.value = null;

      final response = await _apiService.get(
        'bank/search-user?search=$query',
      );

      if (response['status'] == true && response['data'] != null) {
        userSearchResult.value = response['data'];
        final firstName = response['data']['first_name'] ?? '';
        final lastName = response['data']['last_name'] ?? '';
        return '$firstName $lastName'.trim();
      }
      return null;
    } catch (e) {
      userSearchError.value = e.toString();
      print('Error searching user: $e');
      return null;
    } finally {
      userSearchLoading.value = false;
    }
  }

  Future<bool> initiateTransfer({
    String? accountNumber,
    String? bankCode,
    String? userId,
    required double amount,
    String? narration,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final body = userId != null
          ? {
              'user_id': userId,
              'amount': amount.toString(),
              'narration': narration ?? 'Transfer',
              'type': 'internal',
            }
          : {
              'account_number': accountNumber,
              'account_bank': bankCode,
              'amount': amount.toString(),
              'narration': narration ?? 'Transfer',
              'type': 'external',
            };

      final response = await _apiService.post('transfers', body: body);
      return response['status'] == true;
    } catch (e) {
      error.value = e.toString();
      print('Error initiating transfer: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> initiateInAppTransfer({
    required String recipientId,
    required double amount,
    String? narration,
  }) async {
    try {
      isLoading.value = true;
      error.value = '';

      final response = await _apiService.post(
        'bank/in-app-transfer',
        body: {
          'recipient_id': recipientId,
          'amount': amount,
          'narration': narration ?? 'Transfer',
        },
      );

      if (response['status'] == true) {
        final now = DateTime.now();

        // get user data and update balance
        final userController = Get.find<UserController>();
        await userController.getProfile();

        // Navigate to transaction status page
        Get.off(() => TransactionStatusPageInApp(
              status: "success",
              amount: 'NGN ${amount.toStringAsFixed(2)}',
              reference: response['data']['transaction'],
              date: now.toString(),
              recipient: response['data']['recipient']['name'],
              network: 'In-App Transfer',
              productName:
                  'In-App Transfer - ${response['data']['recipient']['name']}',
              error: false,
            ));
      } else {
        throw Exception(response['message'] ?? 'Transfer failed');
      }
    } catch (e) {
      error.value = e.toString();
      print('Error initiating in-app transfer: $e');
      // Navigate to transaction status page with error
      Get.snackbar('Error', error.value);
      Get.off(() => TransactionStatusPageInApp(
            status: "error",
            amount: 'NGN ${amount.toStringAsFixed(2)}',
            reference: '',
            date: DateTime.now().toString(),
            recipient: '',
            network: '',
            productName: 'In-App Transfer',
            error: true,
          ));
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchBanks();
  }
}
