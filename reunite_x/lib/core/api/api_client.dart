import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reunite_x/core/constants/app_constants.dart';


import '../storage/token_storage.dart';
import '../errors/error_handler.dart';

class ApiClient {
  // 🔹 GET
  static Future<http.Response> get(String endpoint) async {
    final token = await TokenStorage.getToken();

    final response = await http.get(
      Uri.parse("${AppConstants.baseUrl}$endpoint"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    return _handleResponse(response);
  }

  // 🔹 POST
  static Future<http.Response> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final token = await TokenStorage.getToken();

    final response = await http.post(
      Uri.parse("${AppConstants.baseUrl}$endpoint"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  // 🔹 PUT
  static Future<http.Response> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final token = await TokenStorage.getToken();

    final response = await http.put(
      Uri.parse("${AppConstants.baseUrl}$endpoint"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  // 🔹 DELETE
  static Future<http.Response> delete(String endpoint) async {
    final token = await TokenStorage.getToken();

    final response = await http.delete(
      Uri.parse("${AppConstants.baseUrl}$endpoint"),
      headers: {
        "Content-Type": "application/json",
        if (token != null) "Authorization": "Bearer $token",
      },
    );

    return _handleResponse(response);
  }

  // 🔴 CENTRALIZED RESPONSE HANDLER
  static http.Response _handleResponse(http.Response response) {
    return ErrorHandler.handle(response);
  }
}