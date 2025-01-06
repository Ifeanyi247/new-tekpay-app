import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tekpayapp/services/api_exception.dart';

class ApiService {
  static const String baseUrl = 'http://172.20.10.2:8000/api';

  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  final _client = http.Client();
  String? _authToken;

  // Set auth token
  void setAuthToken(String token) {
    _authToken = token;
  }

  // Get common headers
  Map<String, String> get _headers {
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
    try {
      final response = await _client.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Generic POST request
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await _client.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _headers,
        body: body != null ? json.encode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Generic PUT request
  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body}) async {
    try {
      final response = await _client.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _headers,
        body: body != null ? json.encode(body) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Generic DELETE request
  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await _client.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _headers,
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
        return json.decode(response.body);
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
      final body = json.decode(response.body);
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
    return ApiException(
      statusCode: 0,
      message: error.toString(),
    );
  }

  // Dispose resources
  void dispose() {
    _client.close();
  }
}
