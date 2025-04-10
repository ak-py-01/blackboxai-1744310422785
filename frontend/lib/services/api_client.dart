import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:sm_erp/services/storage_service.dart';
import 'package:sm_erp/routes/app_pages.dart';

class ApiClient {
  static const String baseUrl = 'http://localhost:8000/api';
  final StorageService _storage = Get.find<StorageService>();

  Future<Map<String, String>> _getHeaders({bool requiresAuth = true}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await _storage.getToken();
      if (token == null) {
        Get.offAllNamed(Routes.LOGIN);
        throw Exception('Authentication token not found');
      }
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<dynamic> get(String endpoint, {bool requiresAuth = true}) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );

      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  Future<dynamic> post(
    String endpoint, {
    dynamic body,
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  Future<dynamic> put(
    String endpoint, {
    dynamic body,
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(body),
      );

      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  Future<dynamic> delete(String endpoint, {bool requiresAuth = true}) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );

      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  Future<dynamic> uploadFile(
    String endpoint,
    List<http.MultipartFile> files, {
    Map<String, String>? fields,
    bool requiresAuth = true,
  }) async {
    try {
      final headers = await _getHeaders(requiresAuth: requiresAuth);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl$endpoint'),
      );

      request.headers.addAll(headers);
      request.files.addAll(files);

      if (fields != null) {
        request.fields.addAll(fields);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      _handleError(e);
    }
  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return json.decode(response.body);
      case 400:
        throw Exception('Bad request: ${response.body}');
      case 401:
        Get.offAllNamed(Routes.LOGIN);
        throw Exception('Unauthorized');
      case 403:
        throw Exception('Forbidden');
      case 404:
        throw Exception('Not found');
      case 500:
        throw Exception('Internal server error');
      default:
        throw Exception('Unknown error occurred');
    }
  }

  void _handleError(dynamic error) {
    if (error is Exception) {
      throw error;
    }
    throw Exception('Unknown error occurred: $error');
  }
}
