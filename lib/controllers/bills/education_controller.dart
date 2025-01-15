import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tekpayapp/services/api_service.dart';

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
}
