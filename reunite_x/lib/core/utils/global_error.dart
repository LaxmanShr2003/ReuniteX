import 'package:flutter/material.dart';

class GlobalSnackbar {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void show(String message) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}