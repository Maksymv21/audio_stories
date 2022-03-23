import 'package:flutter/material.dart';

class GlobalRepo {
  const GlobalRepo._();

  static void showSnackBar({
    required BuildContext context,
    required String title,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          title,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
