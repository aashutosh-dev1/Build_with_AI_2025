import 'dart:developer';

import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static final ImagePickerService _instance = ImagePickerService._internal();
  factory ImagePickerService() {
    return _instance;
  }
  ImagePickerService._internal();
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImage([ImageSource? imageSource]) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: imageSource ?? ImageSource.gallery,
      );
      return image;
    } catch (e) {
      log('Error picking image: $e');
      return null;
    }
  }
}
