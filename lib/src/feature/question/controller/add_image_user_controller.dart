import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:gens/src/core/user.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart'; // For getting the file name

class AddImageUserController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  RxList<File?> updatedImages =
      List<File?>.filled(3, null).obs; // For storing selected images
  RxList<String> imageUrls =
      List<String>.filled(3, '').obs; // For storing image URLs
  RxBool isLoading = false.obs;
  User user = User();

  @override
  void onInit() async {
    // timeSlots = generateTimeSlots();
    await user.loadToken();
    await getUserthreeImage();
    super.onInit();
  }

  // Pick an image and store it in the specific index (0, 1, 2)
  Future<void> pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      updatedImages[index] = File(pickedFile.path);
    }
  }

  Future<void> takeIkmage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      updatedImages[index] = File(pickedFile.path);
    }
  }

  // Save images to Firebase and send them to the API
  Future<void> saveImagesToApi() async {
    isLoading.value = true;

    List<String> newImageUrls = [];

    // Upload images to Firebase if they are updated
    for (int i = 0; i < updatedImages.length; i++) {
      if (updatedImages[i] != null) {
        String downloadUrl = await _uploadImageToFirebase(updatedImages[i]!);
        newImageUrls.add(downloadUrl);
        print("Uploaded image $i URL: $downloadUrl");
      } else {
        print("Image at index $i is not updated");
        newImageUrls.add(imageUrls[i]); // Keep old image URL if not updated
      }
    }

    imageUrls.value = newImageUrls;

    // Call the API with the new image URLs
    await sendImagesToApi(user.userId.value, imageUrls);
  }

  // Upload the selected image to Firebase
  Future<String> _uploadImageToFirebase(File image) async {
    try {
      String fileName = basename(image.path);
      Reference storageRef =
          FirebaseStorage.instance.ref().child('uploads/$fileName');

      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      throw Exception("Failed to upload image to Firebase");
    }
  }

  RxBool isImageDataIncomplere = false.obs;

  // Send image URLs to the new API
  Future<void> sendImagesToApi(int userId, List<String> imageUrls) async {
    const String apiUrl =
        'https://gts-b8dycqbsc6fqd6hg.uaenorth-01.azurewebsites.net/api/UserImages/create';

    // Create JSON payload
    final jsonPayload = jsonEncode({
      "userId": userId,
      "userImage1": imageUrls[0],
      "userImage2": imageUrls[1],
      "userImage3": imageUrls[2]
    });
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonPayload,
      );
      print(response.statusCode);
      print(jsonPayload);

      if (response.statusCode == 200) {
        print("Images sent to API successfully.");
      } else {
        print("Failed to send images to API: ${response.body}");
      }
    } catch (e) {
      print("Error sending images to API: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUserthreeImage() async {
    String apiUrl =
        'https://gts-b8dycqbsc6fqd6hg.uaenorth-01.azurewebsites.net/api/UserImages/${user.userId}';
    try {
      isLoading.value = true;
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Update imageUrls with the URLs from the response
        imageUrls[0] = responseData['userImage1'] ?? '';
        imageUrls[1] = responseData['userImage2'] ?? '';
        imageUrls[2] = responseData['userImage3'] ?? '';
        isImageDataIncomplere.value = imageUrls[0].isEmpty ? true : false;
        isLoading.value = false;
      } else {
        print('The image is empty');
        isLoading.value = false;
        isImageDataIncomplere.value = true;
      }
    } catch (e) {
      print(e);
      isLoading.value = false;
    }
  }
}
