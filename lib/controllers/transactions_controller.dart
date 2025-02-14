import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/models/transaction_model.dart';
import 'package:tekpayapp/services/api_service.dart';
import 'package:tekpayapp/services/api_exception.dart';

class TransactionsController extends GetxController {
  final _api = ApiService();
  final transactions = <Transaction>[].obs;
  final isLoading = false.obs;
  final selectedCategory = 'All Categories'.obs;
  final selectedMonth = 'Mar 2024'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      isLoading.value = true;
      final response = await _api.get('user/transactions');

      if (response['status'] == true) {
        final List<dynamic> transactionData = response['data'];
        transactions.value =
            transactionData.map((json) => Transaction.fromJson(json)).toList();
      } else {
        throw ApiException(
          statusCode: 0,
          message: response['message'] ?? 'Failed to fetch transactions',
        );
      }
    } on ApiException catch (e) {
      print('API Error fetching transactions: ${e.message}');
      Get.snackbar(
        'Error',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error fetching transactions: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch transactions',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<Transaction> get filteredTransactions {
    return transactions.where((transaction) {
      // Filter by category
      if (selectedCategory.value != 'All Categories') {
        final category = selectedCategory.value.toLowerCase();
        if (!transaction.type.toLowerCase().contains(category)) {
          return false;
        }
      }

      // Filter by month (TODO: Implement month filtering)
      // This would compare transaction.transactionDate with selected month

      return true;
    }).toList();
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  void setMonth(String month) {
    selectedMonth.value = month;
  }

  Future<void> refreshTransactions() async {
    await fetchTransactions();
  }

  Future<Map<String, dynamic>> checkTransactionStatus(String requestId) async {
    try {
      final response = await _api.post('bills/status', body: {
        'request_id': requestId,
      });

      if (response['status'] == true) {
        print(response['data']);
        return response['data'];
      } else {
        throw ApiException(
          statusCode: 0,
          message: response['message'] ?? 'Failed to check transaction status',
        );
      }
    } on ApiException catch (e) {
      print('API Error checking transaction status: ${e.message}');
      Get.snackbar(
        'Error',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } catch (e) {
      print('Error checking transaction status: $e');
      Get.snackbar(
        'Error',
        'Failed to check transaction status',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }
}
