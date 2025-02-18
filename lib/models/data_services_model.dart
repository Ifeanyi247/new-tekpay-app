class DataServicesResponse {
  final bool status;
  final String message;
  final DataServicesData data;

  DataServicesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DataServicesResponse.fromJson(Map<String, dynamic> json) {
    return DataServicesResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: DataServicesData.fromJson(json['data'] ?? {}),
    );
  }
}

class DataServicesData {
  final String responseDescription;
  final List<DataService> content;

  DataServicesData({
    required this.responseDescription,
    required this.content,
  });

  factory DataServicesData.fromJson(Map<String, dynamic> json) {
    return DataServicesData(
      responseDescription: json['response_description'] ?? '',
      content: (json['content'] as List?)
              ?.map((e) => DataService.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class DataService {
  final String serviceID;
  final String name;
  final String minimumAmount;
  final int maximumAmount;
  final String convenienceFee;
  final String productType;
  final String image;

  DataService({
    required this.serviceID,
    required this.name,
    required this.minimumAmount,
    required this.maximumAmount,
    required this.convenienceFee,
    required this.productType,
    required this.image,
  });

  factory DataService.fromJson(Map<String, dynamic> json) {
    return DataService(
      serviceID: json['serviceID'] ?? '',
      name: json['name'] ?? '',
      minimumAmount: json['minimium_amount'] ?? '',
      maximumAmount: int.tryParse(json['maximum_amount'].toString()) ?? 0,
      convenienceFee: json['convinience_fee'] ?? '',
      productType: json['product_type'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
