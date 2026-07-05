import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:reunite_x/core/errors/api_exceptions.dart';


class ErrorHandler {
  static http.Response handle(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      return response;
    }

    String message = "Something went wrong";

    try {
      final body = jsonDecode(response.body);

      if (body is Map && body.containsKey("message")) {
        message = body["message"];
      }
    } catch (_) {}

    switch (statusCode) {
      case 400:
        throw AppException(message: message, statusCode: 400);

      case 401:
        throw AppException(message: "Unauthorized. Please login again.", statusCode: 401);

      case 403:
        throw AppException(message: "Access denied.", statusCode: 403);

      case 404:
        throw AppException(message: "Resource not found.", statusCode: 404);

      case 500:
        throw AppException(message: "Server error. Try again later.", statusCode: 500);

      default:
        throw AppException(message: message, statusCode: statusCode);
    }
  }
}