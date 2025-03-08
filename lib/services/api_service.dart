import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:tekpayapp/services/api_exception.dart';
import 'package:get/get.dart';
import 'package:tekpayapp/services/connectivity_service.dart';

class ApiService extends GetxService {
  static const String baseUrl = 'http://172.20.10.3:8000/api';
  // static const String baseUrl = 'https://api.usetekpay.com/api';
  // static const String baseUrl = 'https://tekpay.co/api';

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late http.Client _client;
  String? _authToken;
  final _connectivityService = Get.find<ConnectivityService>();

  ApiService._internal() {
    HttpClient client = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

    _client = IOClient(client);
  }
  // Set auth token
  void setAuthToken(String token) {
    _authToken = token;
  }

  void removeAuthToken() {
    _authToken = null;
  }

  // Get common headers
  Map<String, String> _getHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  // Generic GET request
  Future<dynamic> get(String endpoint) async {
    if (!await _connectivityService.checkConnectivity()) {
      throw ApiException(
        message: 'No internet connection',
        statusCode: 0,
      );
    }

    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _getHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Generic POST request
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    if (!await _connectivityService.checkConnectivity()) {
      throw ApiException(
        message: 'No internet connection',
        statusCode: 0,
      );
    }

    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _getHeaders(),
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Generic PUT request
  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) async {
    if (!await _connectivityService.checkConnectivity()) {
      throw ApiException(
        message: 'No internet connection',
        statusCode: 0,
      );
    }

    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _getHeaders(),
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Generic DELETE request
  Future<dynamic> delete(String endpoint) async {
    if (!await _connectivityService.checkConnectivity()) {
      throw ApiException(
        message: 'No internet connection',
        statusCode: 0,
      );
    }

    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _getHeaders(),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Handle API response
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isNotEmpty) {
        return jsonDecode(response.body);
      }
      return null;
    } else {
      throw ApiException(
        statusCode: response.statusCode,
        message: _getErrorMessage(response),
      );
    }
  }

  // Get error message from response
  String _getErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body);
      if (response.statusCode == 422 && body['errors'] != null) {
        final errors = body['errors'] as Map<String, dynamic>;
        String errorMessage = '';
        errors.forEach((key, value) {
          if (value is List && value.isNotEmpty) {
            errorMessage += '${value[0]}\n';
          }
        });
        return errorMessage.trim();
      }
      return body['message'] ?? 'Unknown error occurred';
    } catch (e) {
      return 'Unknown error occurred';
    }
  }

  // Handle errors
  Exception _handleError(dynamic error) {
    if (error is ApiException) {
      return error;
    }
    print('Non-API Error: $error'); // Log the actual error for debugging
    return ApiException(
      statusCode: 0,
      message: 'An error occurred',
    );
  }

  // Dispose resources
  void dispose() {
    _client.close();
  }
}
