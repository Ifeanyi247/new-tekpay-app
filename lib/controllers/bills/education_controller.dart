import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tekpayapp/services/api_service.dart';
import 'package:tekpayapp/controllers/user_controller.dart';

class EducationVariation {
  final String variationCode;
  final String name;
  final String variationAmount;
  final String fixedPrice;

  EducationVariation({
    required this.variationCode,
    required this.name,
    required this.variationAmount,
    required this.fixedPrice,
  });

  factory EducationVariation.fromJson(Map<String, dynamic> json) {
    return EducationVariation(
      variationCode: json['variation_code'],
      name: json['name'],
      variationAmount: json['variation_amount'],
      fixedPrice: json['fixedPrice'],
    );
  }
}

class EducationVariationsResponse {
  final String serviceName;
  final String serviceId;
  final String convinienceFee;
  final List<EducationVariation> variations;

  EducationVariationsResponse({
    required this.serviceName,
    required this.serviceId,
    required this.convinienceFee,
    required this.variations,
  });

  factory EducationVariationsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return EducationVariationsResponse(
      serviceName: data['ServiceName'],
      serviceId: data['serviceID'],
      convinienceFee: data['convinience_fee'],
      variations: (data['variations'] as List)
          .map((v) => EducationVariation.fromJson(v))
          .toList(),
    );
  }
}

class EducationController extends GetxController {
  final _apiService = Get.find<ApiService>();
  final variations = Rxn<EducationVariationsResponse>();
  final isLoading = false.obs;
  final isPurchasing = false.obs;
  final purchaseError = ''.obs;
  final Rx<Map<String, dynamic>> transactionDetails =
      Rx<Map<String, dynamic>>({});

  Future<void> fetchVariations(String serviceId) async {
    try {
      isLoading.value = true;
      final response =
          await _apiService.get('bills/education/variations/$serviceId');
      variations.value = EducationVariationsResponse.fromJson(response);
    } catch (e) {
      print('Error fetching variations: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> purchaseWaec({
    required String variationCode,
    required String phone,
  }) async {
    try {
      isPurchasing.value = true;
      purchaseError.value = '';

      final response = await _apiService.post(
        'bills/education/waec/purchase',
        body: {
          'variation_code': variationCode,
          'phone': phone,
        },
      );

      if (response['status'] == true) {
        transactionDetails.value = response['data'];

        // Refresh user profile to get updated balance
        final userController = Get.find<UserController>();
        await userController.getProfile();

        return true;
      } else {
        purchaseError.value = response['message'] ?? 'Purchase failed';
        return false;
      }
    } catch (e) {
      purchaseError.value = e.toString();
      return false;
    } finally {
      isPurchasing.value = false;
    }
  }

  Future<bool> purchaseJamb({
    required String variationCode,
    required String phone,
    required String billersCode,
  }) async {
    try {
      isLoading.value = true;
      final response = await _apiService.post(
        'bills/education/jamb/purchase',
        body: {
          'variation_code': variationCode,
          'billersCode': billersCode,
          'phone': phone,
        },
      );

      if (response['status'] == true) {
        transactionDetails.value = response['data'];

        final userController = Get.find<UserController>();
        await userController.getProfile();

        return true;
      } else {
        purchaseError.value = response['message'] ?? 'Transaction failed';
        return false;
      }
    } catch (e) {
      purchaseError.value = e.toString();
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
