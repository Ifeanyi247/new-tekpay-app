class BankResponse {
  final String status;
  final String message;
  final List<Bank> data;

  BankResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BankResponse.fromJson(Map<String, dynamic> json) {
    return BankResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List).map((bank) => Bank.fromJson(bank)).toList(),
    );
  }
}

class Bank {
  final int id;
  final String code;
  final String name;

  Bank({
    required this.id,
    required this.code,
    required this.name,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['id'],
      code: json['code'],
      name: json['name'],
    );
  }
}
