class TransferResponse {
  final String status;
  final String message;
  final TransferData data;

  TransferResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TransferResponse.fromJson(Map<String, dynamic> json) {
    return TransferResponse(
      status: json['status'],
      message: json['message'],
      data: TransferData.fromJson(json['data']),
    );
  }
}

class TransferData {
  final String reference;
  final TransferDetails transferDetails;

  TransferData({
    required this.reference,
    required this.transferDetails,
  });

  factory TransferData.fromJson(Map<String, dynamic> json) {
    return TransferData(
      reference: json['reference'],
      transferDetails: TransferDetails.fromJson(json['transfer_details']),
    );
  }
}

class TransferDetails {
  final int id;
  final String accountNumber;
  final String bankCode;
  final String fullName;
  final String createdAt;
  final String currency;
  final String debitCurrency;
  final double amount;
  final double fee;
  final String status;
  final String reference;
  final dynamic meta;
  final String narration;
  final String completeMessage;
  final int requiresApproval;
  final int isApproved;
  final String bankName;

  TransferDetails({
    required this.id,
    required this.accountNumber,
    required this.bankCode,
    required this.fullName,
    required this.createdAt,
    required this.currency,
    required this.debitCurrency,
    required this.amount,
    required this.fee,
    required this.status,
    required this.reference,
    this.meta,
    required this.narration,
    required this.completeMessage,
    required this.requiresApproval,
    required this.isApproved,
    required this.bankName,
  });

  factory TransferDetails.fromJson(Map<String, dynamic> json) {
    return TransferDetails(
      id: json['id'],
      accountNumber: json['account_number'],
      bankCode: json['bank_code'],
      fullName: json['full_name'],
      createdAt: json['created_at'],
      currency: json['currency'],
      debitCurrency: json['debit_currency'],
      amount: json['amount'].toDouble(),
      fee: json['fee'].toDouble(),
      status: json['status'],
      reference: json['reference'],
      meta: json['meta'],
      narration: json['narration'],
      completeMessage: json['complete_message'],
      requiresApproval: json['requires_approval'],
      isApproved: json['is_approved'],
      bankName: json['bank_name'],
    );
  }
}
