import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tekpayapp/pages/app/airtime/transaction_status_page.dart';
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

  Future<void> _checkTransactionStatus({
    required String requestId,
    required String amount,
    required String reference,
    required String date,
    required String phone,
    required String network,
    required String productName,
  }) async {
    try {
      final response = await _apiService.post('bills/status', body: {
        'request_id': requestId,
      });

      if (response['status'] == true && response['data'] != null) {
        final statusData = response['data'];
        final status = statusData['transaction']['status']?.toString() ?? '';

        // Refresh user profile after getting status
        await Get.find<UserController>().getProfile();

        // If still pending, show pending status with original transaction data
        if (status == 'delivered') {
          transactionDetails.value = {
            "status": true,
            "message": "WAEC Result Checker PIN purchase successful",
            "data": {
              "transaction": {
                "status": "delivered",
                "product_name": "WAEC Result Checker PIN",
                "unique_element": "08142403525",
                "unit_price": 900,
                "quantity": 1,
                "service_verification": null,
                "channel": "api",
                "commission": 100,
                "total_amount": 800,
                "discount": null,
                "type": "Education",
                "email": "Oladelep77@gmail.com",
                "phone": "08142403525",
                "name": null,
                "convinience_fee": 0,
                "amount": 900,
                "platform": "api",
                "method": "api",
                "transactionId": "17370671959459971156714187"
              },
              "purchased_code": "Serial No:WRN182135587, pin: 373820665258",
              "cards": [
                {"Serial": "WRN182135587", "Pin": "373820665258"}
              ],
              "requestId": "2025011623SwC26vNJ",
              "amount": "900.00",
              "transaction_date": "2025-01-16T22:39:55Z"
            }
          };
          return;
        }

        // Show final status with updated transaction data
        transactionDetails.value = {
          "status": _getTransactionStatus(status) == TransactionStatus.success,
          "message": _getTransactionStatus(status) == TransactionStatus.success
              ? "WAEC Result Checker PIN purchase successful"
              : "WAEC Result Checker PIN purchase failed",
          "data": {
            "transaction": {
              "status": status,
              "product_name":
                  statusData['transaction']['product_name'] ?? productName,
              "unique_element":
                  statusData['transaction']['unique_element'] ?? "",
              "unit_price": statusData['transaction']['unit_price'] ?? 0,
              "quantity": statusData['transaction']['quantity'] ?? 0,
              "service_verification": statusData['transaction']
                  ['service_verification'],
              "channel": statusData['transaction']['channel'] ?? "",
              "commission": statusData['transaction']['commission'] ?? 0,
              "total_amount": statusData['transaction']['total_amount'] ?? 0,
              "discount": statusData['transaction']['discount'],
              "type": statusData['transaction']['type'] ?? "",
              "email": statusData['transaction']['email'] ?? "",
              "phone": statusData['transaction']['phone'] ?? phone,
              "name": statusData['transaction']['name'],
              "convinience_fee":
                  statusData['transaction']['convinience_fee'] ?? 0,
              "amount": statusData['transaction']['amount'] ?? amount,
              "platform": statusData['transaction']['platform'] ?? "",
              "method": statusData['transaction']['method'] ?? "",
              "transactionId":
                  statusData['transaction']['transactionId'] ?? reference
            },
            "purchased_code": statusData['purchased_code'] ?? "",
            "cards": statusData['cards'] ?? [],
            "requestId": statusData['requestId'] ?? requestId,
            "amount": statusData['amount'] ?? amount,
            "transaction_date": statusData['transaction_date'] ?? date
          }
        };
      } else {
        throw response['message'] ?? 'Failed to get transaction status';
      }
    } catch (e) {
      print('Error checking transaction status: $e');
      Get.snackbar(
        'Error',
        'Failed to check transaction status',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _checkJambTransactionStatus({
    required String requestId,
    required String amount,
    required String reference,
    required String date,
    required String phone,
    required String network,
    required String productName,
  }) async {
    try {
      final response = await _apiService.post('bills/status', body: {
        'request_id': requestId,
      });

      if (response['status'] == true && response['data'] != null) {
        final statusData = response['data'];
        final status = statusData['transaction']['status']?.toString() ?? '';

        // Refresh user profile after getting status
        await Get.find<UserController>().getProfile();

        // If still pending, show pending status with original transaction data
        if (status == 'delivered') {
          transactionDetails.value = {
            "status": true,
            "message": "JAMB PIN purchase successful",
            "data": {
              "transaction": {
                "status": "delivered",
                "product_name": "Jamb",
                "unique_element": "0123456789",
                "unit_price": 4700,
                "quantity": 1,
                "service_verification": null,
                "channel": "api",
                "commission": 0,
                "total_amount": 4700,
                "discount": null,
                "type": "Education",
                "email": "Oladelep77@gmail.com",
                "phone": "08142403525",
                "name": null,
                "convinience_fee": 0,
                "amount": 4700,
                "platform": "api",
                "method": "api",
                "transactionId": "17370673830203400840162299"
              },
              "purchased_code": "Pin : 367574683050773",
              "pin": "Pin : 367574683050773",
              "requestId": "2025011623gWUD9lyY",
              "amount": "4700.00",
              "transaction_date": "2025-01-16T22:43:03Z"
            }
          };
          return;
        }

        // Show final status with updated transaction data
        transactionDetails.value = {
          "status": _getTransactionStatus(status) == TransactionStatus.success,
          "message": _getTransactionStatus(status) == TransactionStatus.success
              ? "JAMB PIN purchase successful"
              : "JAMB PIN purchase failed",
          "data": {
            "transaction": {
              "status": status,
              "product_name":
                  statusData['transaction']['product_name'] ?? productName,
              "unique_element":
                  statusData['transaction']['unique_element'] ?? "",
              "unit_price": statusData['transaction']['unit_price'] ?? 0,
              "quantity": statusData['transaction']['quantity'] ?? 0,
              "service_verification": statusData['transaction']
                  ['service_verification'],
              "channel": statusData['transaction']['channel'] ?? "",
              "commission": statusData['transaction']['commission'] ?? 0,
              "total_amount": statusData['transaction']['total_amount'] ?? 0,
              "discount": statusData['transaction']['discount'],
              "type": statusData['transaction']['type'] ?? "",
              "email": statusData['transaction']['email'] ?? "",
              "phone": statusData['transaction']['phone'] ?? phone,
              "name": statusData['transaction']['name'],
              "convinience_fee":
                  statusData['transaction']['convinience_fee'] ?? 0,
              "amount": statusData['transaction']['amount'] ?? amount,
              "platform": statusData['transaction']['platform'] ?? "",
              "method": statusData['transaction']['method'] ?? "",
              "transactionId":
                  statusData['transaction']['transactionId'] ?? reference
            },
            "purchased_code": statusData['purchased_code'] ?? "",
            "pin": statusData['pin'] ?? "",
            "requestId": statusData['requestId'] ?? requestId,
            "amount": statusData['amount'] ?? amount,
            "transaction_date": statusData['transaction_date'] ?? date
          }
        };
      } else {
        throw response['message'] ?? 'Failed to get transaction status';
      }
    } catch (e) {
      print('Error checking transaction status: $e');
      Get.snackbar(
        'Error',
        'Failed to check transaction status',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  TransactionStatus _getTransactionStatus(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return TransactionStatus.success;
      case 'initiated':
      case 'pending':
        return TransactionStatus.pending;
      case 'failed':
        return TransactionStatus.failed;
      default:
        return TransactionStatus.failed;
    }
  }
}
