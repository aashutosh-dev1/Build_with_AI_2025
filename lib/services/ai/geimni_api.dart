import 'dart:developer';
import 'dart:typed_data';

import 'package:build_with_ai_2025/services/network/upload_image_to_cloudinary.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';

class GeimniApi {
  static final GeimniApi _instance = GeimniApi._internal();
  factory GeimniApi() {
    return _instance;
  }
  GeimniApi._internal();

  // Initialize the Vertex AI service and create a `GenerativeModel` instance
  // Specify a model that supports your use case
  final model = FirebaseVertexAI.instance.generativeModel(
    model: 'gemini-2.0-flash',
  );
  // Initialize the Vertex AI service and create an `ImagenModel` instance
  // Specify an Imagen 3 model that supports your use case
  final imageModel = FirebaseVertexAI.instance.imagenModel(
    model: 'imagen-3.0-generate-002',
    // Configure the model to generate multiple images for each request
    // See: https://firebase.google.com/docs/vertex-ai/model-parameters
    generationConfig: ImagenGenerationConfig(numberOfImages: 1),
  );

  // Generate a response using the model
  Future<String> generateResponse(String text) async {
    try {
      final prompt = [
        Content.text(
          '''Write a professional LinkedIn post based on the following input: $text. Ensure the post flows naturally without leading or trailing dashes or extra blank lines. Include relevant hashtags. Return only the formatted LinkedIn post content.''',
        ),
      ];
      final response = await model.generateContent(prompt);
      log('Generated response: ${response.text}');
      return response.text ?? "Not able to generate a response";
    } catch (e) {
      return 'Error generating response: $e';
    }
  }

  // Generate a response using the model with an image
  Future<String> generateResponseWithImage(String text) async {
    try {
      log('Generating image for prompt: $text');
      final prompt = text;

      final response = await imageModel.generateImages(prompt);
      if (response.filteredReason != null) {
        debugPrint(response.filteredReason);
        return 'Image generation filtered: ${response.filteredReason}';
      }

      if (response.images.isNotEmpty) {
        for (var image in response.images) {
          final Uint8List imageData = image.bytesBase64Encoded;

          final uploadService = UploadImageToCloudinary();
          final imageUrl = await uploadService.uploadToCloudinaryBase64(
            imageData,
          );
          debugPrint('Uploaded Image URL: $imageUrl');
          return imageUrl ?? 'No URL returned';
        }
      } else {
        debugPrint('Error: No images were generated.');
        return 'No images were generated.';
      }
      return 'No images were generated.';
    } catch (e) {
      debugPrint('Error generating image: $e');
      return 'Error generating image: $e';
    }
  }
}
