import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerButton extends StatefulWidget {
  const ImagePickerButton({super.key});

  @override
  State<ImagePickerButton> createState() => _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  List<XFile>? _imageFiles = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImages() async {
    // Pick multiple images
    final List<XFile> selectedImages = await _picker.pickMultiImage();

    setState(() {
      // Allow only up to 3 images
      _imageFiles = selectedImages.take(3).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick Images')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: pickImages,
            child: const Text('Pick up to 3 Images'),
          ),
          const SizedBox(height: 20),
          // Display selected images
          if (_imageFiles != null && _imageFiles!.isNotEmpty)
            Wrap(
              children: _imageFiles!.map((image) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(
                    File(image.path),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

void main() => runApp(const MaterialApp(home: ImagePickerButton()));
