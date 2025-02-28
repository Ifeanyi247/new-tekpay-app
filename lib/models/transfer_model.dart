class TransferModel {
  final int id;
  final String userId;
  final String accountName;
  final String accountNumber;
  final String amount;
  final String accountBank;
  final String accountCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransferModel({
    required this.id,
    required this.userId,
    required this.accountName,
    required this.accountNumber,
    required this.amount,
    required this.accountBank,
    required this.accountCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransferModel.fromJson(Map<String, dynamic> json) {
    return TransferModel(
      id: json['id'],
      userId: json['user_id'],
      accountName: json['account_name'],
      accountNumber: json['account_number'],
      amount: json['amount'],
      accountBank: json['account_bank'],
      accountCode: json['account_code'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
