import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddProductController extends GetxController {
  var updatedImage = Rx<File?>(null);
  var message = TextEditingController();
  var productDescription = ''.obs;
  var isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();
  User user = User();

  @override
  void onInit() async {
    await user.loadToken();
    await getProduct(); // Fetch product details on initialization
    super.onInit();
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        updatedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      // Handle errors
      print('Error picking image: $e');
    }
  }

  Future<void> uploadImageToFirebase(File imageFile) async {
    try {
      isLoading.value = true;

      // Upload to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('products/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageRef.putFile(imageFile);

      // Get the download URL
      String downloadURL = await storageRef.getDownloadURL();

      // Now send the download URL to your API
      await sendImageToApi(downloadURL);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendImageToApi(String imageUrl) async {
    var requestBody = {
      "userId": user.userId.value,
      "productDescription": message.text,
      "productImage": imageUrl,
    };

    final response = await http.post(
      Uri.parse(
          'https://gts-b8dycqbsc6fqd6hg.uaenorth-01.azurewebsites.net/api/Questionnaire/post-product-section'), // Replace with your API URL
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      Get.back();
      print('Data sent successfully: ${response.body}');
    } else {
      // Handle error
      print('Failed to send data: ${response.statusCode}');
    }
  }

  Future<void> getProduct() async {
    isLoading.value = true;
    final response = await http.get(
      Uri.parse(
          'https://gts-b8dycqbsc6fqd6hg.uaenorth-01.azurewebsites.net/api/Questionnaire/get-product-details/${user.userId.value}'), // Replace with your API URL
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    print(
        'https://gts-b8dycqbsc6fqd6hg.uaenorth-01.azurewebsites.net/api/Questionnaire/get-product-details/${user.userId.value}');
    print(response.body);
    if (response.statusCode == StatusCode.ok) {
      var data = jsonDecode(response.body);
      isLoading.value = true;

      if (data != null) {
        message.text = data['productDescription'] ?? '';

        // Update the image field (this assumes the image URL is in the response)
        if (data['productImage'] != null && data['productImage'].isNotEmpty) {
          updatedImage.value = await downloadImage(data['productImage']);
        }
        isLoading.value = false;
      }
    } else {
      // Handle error
      print('Failed to get product: ${response.statusCode}');
    }
  }

  // Function to download the image from a URL and return a File
  Future<File> downloadImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    final tempDir = Directory.systemTemp;
    final file =
        File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await file.writeAsBytes(bytes);
    return file;
  }
}
