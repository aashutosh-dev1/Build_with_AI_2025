import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RemoteService {
  static final RemoteService _instance = RemoteService._internal();
  factory RemoteService() {
    return _instance;
  }
  RemoteService._internal();

  Future<bool> postToLinkedinAPI({
    required String text,
    required String imageUrl,
  }) async {
    final url = Uri.parse(
      "Webhook URL",
    );
    final body = {"text": text, "image_url": imageUrl}; // Replace with your actual body structure
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        debugPrint('Post request successful');
        return true;
      } else {
        debugPrint('Post request failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      debugPrint('Error making post request: $e');
      return false;
    }
  }
}
