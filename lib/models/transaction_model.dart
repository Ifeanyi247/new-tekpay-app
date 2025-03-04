import 'package:flutter/material.dart';

class WaecCard {
  final String serial;
  final String pin;

  WaecCard({
    required this.serial,
    required this.pin,
  });

  factory WaecCard.fromJson(Map<String, dynamic> json) {
    return WaecCard(
      serial: json['Serial'],
      pin: json['Pin'],
    );
  }
}

class Transaction {
  final int id;
  final String userId;
  final String requestId;
  final String transactionId;
  final String reference;
  final String amount;
  final String commission;
  final String totalAmount;
  final String type;
  final String status;
  final String serviceId;
  final String phone;
  final String productName;
  final String platform;
  final String channel;
  final String method;
  final String responseCode;
  final String responseMessage;
  final String? purchasedCode;
  final String? pin;
  final List<WaecCard>? cards;
  final DateTime transactionDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transaction({
    required this.id,
    required this.userId,
    required this.requestId,
    required this.transactionId,
    required this.reference,
    required this.amount,
    required this.commission,
    required this.totalAmount,
    required this.type,
    required this.status,
    required this.serviceId,
    required this.phone,
    required this.productName,
    required this.platform,
    required this.channel,
    required this.method,
    required this.responseCode,
    required this.responseMessage,
    this.purchasedCode,
    this.pin,
    this.cards,
    required this.transactionDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      userId: json['user_id'],
      requestId: json['request_id'],
      transactionId: json['transaction_id'],
      reference: json['reference'],
      amount: json['amount'],
      commission: json['commission'],
      totalAmount: json['total_amount'],
      type: json['type'],
      status: json['status'],
      serviceId: json['service_id'],
      phone: json['phone'],
      productName: json['product_name'],
      platform: json['platform'],
      channel: json['channel'],
      method: json['method'],
      responseCode: json['response_code'],
      responseMessage: json['response_message'],
      purchasedCode: json['purchased_code'],
      pin: json['pin'],
      cards: json['cards'] != null
          ? (json['cards'] as List)
              .map((card) => WaecCard.fromJson(card))
              .toList()
          : null,
      transactionDate: DateTime.parse(json['transaction_date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Helper method to get transaction icon based on type
  IconData get icon {
    switch (type.toLowerCase()) {
      case 'airtime':
        return Icons.phone_android;
      case 'data':
        return Icons.wifi;
      case 'electricity':
        return Icons.flash_on;
      case 'tv subscription':
        return Icons.tv;
      case 'transfer':
        return Icons.arrow_upward;
      case 'add_money':
        return Icons.add;
      case 'waec result checker':
        return Icons.school;
      case 'jamb result checker':
        return Icons.school;
      default:
        return Icons.receipt;
    }
  }

  // Helper method to get formatted amount with sign
  String get formattedAmount {
    final isDebit = type.toLowerCase().contains('purchase') ||
        type.toLowerCase() == 'transfer' ||
        type.toLowerCase().contains('checker');
    return '${isDebit ? "-" : ""}NGN $amount';
  }

  // Helper method to check if transaction is education related
  bool get isEducation {
    final lowerType = type.toLowerCase();
    return lowerType.contains('waec') || lowerType.contains('jamb');
  }

  // Helper method to get education pin/serial details
  String? get educationDetails {
    if (!isEducation) return null;
    return purchasedCode ??
        (cards?.isNotEmpty == true
            ? 'Serial: ${cards![0].serial}, PIN: ${cards![0].pin}'
            : pin);
  }

  // Helper method to get transaction title
  String get title {
    switch (type.toLowerCase()) {
      case 'airtime':
        return 'Airtime Purchase ($serviceId)'.toUpperCase();
      case 'data':
        return 'Data Purchase ($serviceId)'.toUpperCase();
      case 'electricity':
        return 'Electricity Purchase ($serviceId)'.toUpperCase();
      case 'tv subscription':
        return 'TV Subscription ($serviceId)'.toUpperCase();
      case 'transfer':
        return 'Transfer to $productName';
      case 'add_money':
        return 'Add Money';
      case 'waec result checker':
        return 'WAEC Result Checker';
      case 'jamb result checker':
        return 'JAMB Result Checker';
      default:
        return type.replaceAll('_', ' ').toUpperCase();
    }
  }

  // Helper method to get transaction subtitle
  String get subtitle {
    if (isEducation) {
      return educationDetails ?? 'Phone: $phone';
    }
    if (type.toLowerCase().contains('purchase')) {
      return 'Phone: $phone';
    }
    return 'TrnxRef: $reference';
  }
}
