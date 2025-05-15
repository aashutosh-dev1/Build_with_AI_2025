import 'dart:developer';

import 'package:build_with_ai_2025/services/ai/geimni_api.dart';
import 'package:build_with_ai_2025/services/network/remote_service.dart';
import 'package:build_with_ai_2025/services/network/upload_image_to_cloudinary.dart';
import 'package:build_with_ai_2025/widgets/custom_ts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _promptController = TextEditingController();
  String _response = '';
  bool _isLoading = false;
  XFile? _selectedImage;
  String? _imageUrl;

  Future<void> _generateResponse() async {
    setState(() {
      _isLoading = true;
    });
    final String text = _promptController.text;
    final String response = await GeimniApi().generateResponse(text);
    setState(() {
      _response = response;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Build with AI-025',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Center(
              child: CustomTs(
                text: 'Automate your content with AI',
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _promptController,
                maxLines: 2,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your prompt here..',
                  hintText: 'Type something...',
                ),
              ),
            ),

            const SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                  onPressed: () => _generateResponse(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: const Text('Generate', style: TextStyle(fontSize: 16)),
                ),
            const SizedBox(height: 20),

            // Display the generated response
            _response.isNotEmpty
                ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        _response,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const CustomTs(
                            text:
                                'Do you want to genrate image for this content? or will you pick image from your gallery',
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                          const SizedBox(height: 10),
                          (_imageUrl == null)
                              ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      GeimniApi geimniApi = GeimniApi();
                                      final imageGenerated = await geimniApi
                                          .generateResponseWithImage(
                                            _promptController.text,
                                          );
                                      log(
                                        'Generated image URL: $imageGenerated',
                                      );
                                      setState(() {
                                        _imageUrl = imageGenerated;
                                      });
                                    },

                                    child: const Text('Generate Image'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      ImagePicker()
                                          .pickImage(
                                            source: ImageSource.gallery,
                                          )
                                          .then((pickedFile) async {
                                            if (pickedFile != null) {
                                              setState(() {
                                                _selectedImage = pickedFile;
                                              });
                                              final uploadImageToCloudinary =
                                                  UploadImageToCloudinary();
                                              final imageFromCloud =
                                                  await uploadImageToCloudinary
                                                      .uploadImageToCloudinary(
                                                        _selectedImage!.path,
                                                      );
                                              setState(() {
                                                _imageUrl = imageFromCloud;
                                              });

                                              log(
                                                'Picked image: ${pickedFile.path} --> $imageFromCloud',
                                              );
                                            } else {
                                              log('No image selected.');
                                            }
                                          });
                                    },

                                    child: const Text('Select from Gallery'),
                                  ),
                                ],
                              )
                              : Stack(
                                children: [
                                  Container(
                                    height: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(_imageUrl ?? ""),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      color: Colors.black54,
                                      child: IconButton(
                                        iconSize: 30,
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.yellowAccent,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _selectedImage = null;
                                            _imageUrl = null;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                          const SizedBox(height: 20),

                          ElevatedButton(
                            onPressed: () {
                              if (_imageUrl != null) {
                                RemoteService().postToLinkedinAPI(
                                  text: _response,
                                  imageUrl: _imageUrl ?? "",
                                );
                              } else {
                                log('Image URL is null');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff0077B5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomTs(
                                  text: 'Post to LinkedIn',
                                  color: Colors.white,
                                  fontSize: 14.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
