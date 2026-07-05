



import 'dart:async';

import 'package:flutter/services.dart';
import 'package:reunite_x/core/errors/api_exceptions.dart';
import 'package:reunite_x/core/utils/global_error.dart';

class ErrorHandler {
  static void handle(dynamic error) {
    if (error is AppException) {
      _showError(error.message);
    } else if (error is TimeoutException) {
      _showError("Request timed out. Please try again.");
    } else if (error is PlatformException) {
      _showError("Platform error: ${error.message}");
    } else {
      _showError("Something went wrong!");
    }
  }

static void _showError(String message) {
  GlobalSnackbar.show(message);
}
}