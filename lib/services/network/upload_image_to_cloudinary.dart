import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UploadImageToCloudinary {
  static final UploadImageToCloudinary _instance =
      UploadImageToCloudinary._internal();
  factory UploadImageToCloudinary() {
    return _instance;
  }
  UploadImageToCloudinary._internal();

  Future<String> uploadImageToCloudinary(String imagePath) async {
    final String cloudName = 'dzpq3bzgz';
    final String uploadPreset = 'upload from flutter';

    final Uri uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload?upload_preset=$uploadPreset',
    );

    final http.MultipartRequest request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('file', imagePath));

    try {
      final http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        final String responseString = await response.stream.bytesToString();
        final Map<String, dynamic> responseData = json.decode(responseString);
        return responseData['secure_url'];
      } else {
        throw Exception('Failed to upload image');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  Future<String?> uploadToCloudinaryBase64(Uint8List imageBytes) async {
    final String cloudName = 'dzpq3bzgz';
    final String uploadPreset = 'upload from flutter';

    final base64Image = base64Encode(imageBytes);
    final dataUri = 'data:image/png;base64,$base64Image';

    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final response = await http.post(
      url,
      body: {'file': dataUri, 'upload_preset': uploadPreset},
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['secure_url'];
    } else {
      debugPrint('Cloudinary upload failed: ${response.body}');
      return null;
    }
  }
}
