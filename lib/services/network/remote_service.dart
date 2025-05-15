import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RemoteService {
  static final RemoteService _instance = RemoteService._internal();
  factory RemoteService() {
    return _instance;
  }
  RemoteService._internal();

  Future<void> postToLinkedinAPI({
    required String text,
    required String imageUrl,
  }) async {
    final url = Uri.parse(
      "https://hook.eu2.make.com/wwjiuexceroh98thypo754ksz17jd6eg",
    );
    final body = {"text": text, "image_url": imageUrl};
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        debugPrint('Post request successful');
      } else {
        debugPrint('Post request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error making post request: $e');
    }
  }
}
