import 'package:flutter/material.dart';

class Utils {
  static void showFunToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '✨ Boom! Your content is cooking... 🍳',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.deepPurple,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }
}
