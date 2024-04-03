import 'package:flutter/material.dart';

class MyMessageHandler {
  static void showSnackbar(
    var _scaffoldKey,
    String message,
  ) {
    _scaffoldKey.currentState!.clearSnackBars();
    _scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
          message,
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
