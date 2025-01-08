import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/services/api_service.dart';
import 'package:tekpayapp/services/api_exception.dart';
import 'package:tekpayapp/models/data_plan_model.dart';

class DataController extends GetxController {
  final _api = ApiService();
  final plans = Rx<DataPlanResponse?>(null);
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final String serviceId;

  DataController(this.serviceId);

  @override
  void onInit() {
    super.onInit();
    fetchDataPlans();
  }

  Future<void> fetchDataPlans() async {
    try {
      isLoading.value = true;
      final response = await _api.get('bills/data/plans/$serviceId');

      if (response['status'] == true) {
        plans.value = DataPlanResponse.fromJson(response['data']);
      } else {
        throw ApiException(
          statusCode: 0,
          message: response['message'] ?? 'Failed to fetch data plans',
        );
      }
    } on ApiException catch (e) {
      print('API Error fetching data plans: ${e.message}');
      Get.snackbar(
        'Error',
        e.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error fetching data plans: $e');
      Get.snackbar(
        'Error',
        'Failed to fetch data plans',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<DataPlanVariation> get filteredPlans {
    if (plans.value == null) return [];

    final query = searchQuery.value.toLowerCase();
    return plans.value!.variations.where((plan) {
      return plan.name.toLowerCase().contains(query);
    }).toList();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  double getDiscountedPrice(String amount) {
    // Apply 2% discount
    final originalPrice = double.tryParse(amount) ?? 0.0;
    return originalPrice * 0.98;
  }
}
