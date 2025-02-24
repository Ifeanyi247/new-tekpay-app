class AccountVerifyResponse {
  final String status;
  final String message;
  final AccountData data;

  AccountVerifyResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AccountVerifyResponse.fromJson(Map<String, dynamic> json) {
    return AccountVerifyResponse(
      status: json['status'],
      message: json['message'],
      data: AccountData.fromJson(json['data']),
    );
  }
}

class AccountData {
  final String accountName;
  final String accountNumber;

  AccountData({
    required this.accountName,
    required this.accountNumber,
  });

  factory AccountData.fromJson(Map<String, dynamic> json) {
    return AccountData(
      accountName: json['account_name'],
      accountNumber: json['account_number'],
    );
  }
}
