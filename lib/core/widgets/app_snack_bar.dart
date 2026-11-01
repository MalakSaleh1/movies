import 'package:flutter/material.dart';

class AppSnackBar {
  AppSnackBar._();

  static void show(BuildContext context, String message,
      {bool error = false}) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: error ? Colors.red : Colors.green,
          content: Text(message),
        ),
      );
  }

  static void success(BuildContext context, String message) =>
      show(context, message);

  static void error(BuildContext context, String message) =>
      show(context, message, error: true);
}
