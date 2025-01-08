class DataPlanVariation {
  final String code;
  final String name;
  final String amount;
  final String fixedPrice;

  DataPlanVariation({
    required this.code,
    required this.name,
    required this.amount,
    required this.fixedPrice,
  });

  factory DataPlanVariation.fromJson(Map<String, dynamic> json) {
    return DataPlanVariation(
      code: json['variation_code'] ?? '',
      name: json['name'] ?? '',
      amount: json['variation_amount'] ?? '0.00',
      fixedPrice: json['fixedPrice'] ?? 'Yes',
    );
  }
}

class DataPlanResponse {
  final String serviceName;
  final String serviceId;
  final String convenienceFee;
  final List<DataPlanVariation> variations;

  DataPlanResponse({
    required this.serviceName,
    required this.serviceId,
    required this.convenienceFee,
    required this.variations,
  });

  factory DataPlanResponse.fromJson(Map<String, dynamic> json) {
    return DataPlanResponse(
      serviceName: json['ServiceName'] ?? '',
      serviceId: json['serviceID'] ?? '',
      convenienceFee: json['convinience_fee'] ?? '0 %',
      variations: (json['varations'] as List?)
              ?.map((v) => DataPlanVariation.fromJson(v))
              .toList() ??
          [],
    );
  }
}
