import 'package:flutter/material.dart';

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
      transactionDate: DateTime.parse(json['transaction_date']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Helper method to get transaction icon based on type
  IconData get icon {
    switch (type) {
      case 'airtime_purchase':
        return Icons.phone_android;
      case 'data_purchase':
        return Icons.wifi;
      case 'electricity_purchase':
        return Icons.flash_on;
      case 'tv_subscription':
        return Icons.tv;
      case 'transfer':
        return Icons.arrow_upward;
      case 'add_money':
        return Icons.add;
      default:
        return Icons.receipt;
    }
  }

  // Helper method to get formatted amount with sign
  String get formattedAmount {
    final isDebit = type.contains('purchase') || type == 'transfer';
    return '${isDebit ? "-" : ""}₦$amount';
  }

  // Helper method to get transaction title
  String get title {
    switch (type) {
      case 'airtime_purchase':
        return 'Airtime Purchased ($serviceId)'.toUpperCase();
      case 'data_purchase':
        return 'Data Purchased ($serviceId)'.toUpperCase();
      case 'electricity_purchase':
        return 'Electricity Purchased ($serviceId)'.toUpperCase();
      case 'tv_subscription':
        return 'TV Subscription ($serviceId)'.toUpperCase();
      case 'transfer':
        return 'Transfer to $productName';
      case 'add_money':
        return 'Add Money';
      default:
        return type.replaceAll('_', ' ').toUpperCase();
    }
  }

  // Helper method to get transaction subtitle
  String get subtitle {
    if (type.contains('purchase')) {
      return 'Phone No: $phone';
    } else {
      return 'TrnxRef: $reference';
    }
  }
}
