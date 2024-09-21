import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/core/utils/snack_bar.dart';
import 'package:gens/src/feature/doctor_profile/model/doctor_model.dart';
import 'package:gens/src/feature/login/view/pages/login_page.dart';
import 'package:gens/src/feature/vendor_profile/model/vendor_image.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path/path.dart'; // For extracting filename
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class VendorProfileController extends GetxController {
  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());
  final name = TextEditingController();
  final email = TextEditingController();
  final userType = TextEditingController();
  final description = TextEditingController();
  final phone = TextEditingController();
  final location = TextEditingController();
  final image = TextEditingController();
  Rx<DoctorModelById> vendor = DoctorModelById(
          vendorId: 1,
          name: "name",
          type: "type",
          location: 'location',
          pastBookings: 1,
          avgRating: 1,
          reviewCount: 1,
          description: "description",
          workingTime: "workingTime",
          reviews: [],
          businessImages: [
            BusinessImages(
                id: 1,
                vendorID: 1,
                imgUrl1: "imgUrl1",
                imgUrl2: "imgUrl2",
                imgUrl3: "imgUrl3",
                vendor: "vendor")
          ],
          phone: "phone")
      .obs;
  RxList<File?> updatedImages = List<File?>.filled(3, null).obs;
  RxList<String> imageUrls = <String>[].obs;
  RxBool isLoading = false.obs;
  User user = User();
  @override
  Future<void> onInit() async {
    await user.loadVendorId();
    await getVendorsById();

    super.onInit();
  }

  Future<void> getVendorsById() async {
    isLoading.value = true;

    if (await networkInfo.isConnected) {
      try {
        final response = await http.get(
          Uri.parse("${EndPoints.getVendorId}/${user.vendorId}/details"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );
        // print("{{{{{{id}}}}}}");
        // print(user.vendorId);
        // print("{{{{{{{{id}}}}}}}}");

        if (response.statusCode == StatusCode.ok) {
          try {
            final dynamic jsonData = json.decode(response.body);

            vendor.value = DoctorModelById.fromJson(jsonData);
            name.text = vendor.value.name;
            location.text = vendor.value.location;
            // email.text = vendor.value.email;
            description.text = vendor.value.description;
            phone.text = vendor.value.phone;
            userType.text = vendor.value.type;
            image.text = vendor.value.businessImages.first.imgUrl1;
            imageUrls.clear();
            // Update the images list
            imageUrls.add(vendor.value.businessImages.first.imgUrl1);
            imageUrls.add(vendor.value.businessImages.first.imgUrl2);
            imageUrls.add(vendor.value.businessImages.first.imgUrl3);
            // vendor.value.businessImages.map((img) => img.imgUrl1).toList();
            print(isLoading.value);
            isLoading.value = false;
            print(isLoading.value);
          } catch (e) {
            Get.snackbar(
              "Error",
              "Failed to parse vendor data",
              snackPosition: SnackPosition.BOTTOM,
            );
          }
          isLoading.value = false;
        } else {
          Get.snackbar(
            "Error",
            "Failed to fetch vendors",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
        isLoading.value = false;
      } catch (e) {
        print(e);
      }
    } else {
      Get.snackbar(
        "No Internet Connection",
        "Please check your network settings",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void logout() async {
    await user.clearVendorId();
    Get.offAll(() => const LoginPage());
  }

  Future<void> updateUser(context) async {
    if (await networkInfo.isConnected) {
      isLoading.value = true;
      var body = jsonEncode({
        "email": email.text.trim(),
        "name": name.text.trim(),
        "address": location.text.trim(),
        "description": description.text.trim(),
        "phone": "string"
      });
      try {
        final response = await http.put(
            Uri.parse(
                "https://gts-b8dycqbsc6fqd6hg.uaenorth-01.azurewebsites.net/api/Vendor/${user.vendorId.value}/basic-info"),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: body);
        print(response.body);
        if (response.statusCode == StatusCode.ok) {
          isLoading.value = false;
          showSnackBar("Success", "Data Updated Successfully", Colors.green);
          getVendorsById();
        } else {}
      } catch (e) {
        isLoading.value = false;

        print(e);
      }
    } else {
      isLoading.value = false;

      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: 'No Internet Connection'.tr,
        ),
      );
    }
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      updatedImages[index] = File(pickedFile.path);
    }
  }

  Future<void> saveImagesToApi() async {
    isLoading.value = true;

    List<String> newImageUrls = [];

    for (int i = 0; i < imageUrls.length; i++) {
      if (updatedImages[i] != null) {
        // Upload the image to Firebase and get the download URL
        String downloadUrl = await _uploadImageToFirebase(updatedImages[i]!);
        newImageUrls.add(downloadUrl);
        print(downloadUrl);
      } else {
        print(imageUrls[i]);
        newImageUrls.add(imageUrls[i]);
      }
    }

    imageUrls.value = newImageUrls;

    // Call the API with the new image URLs
    await sendImagesToApi(imageUrls);
  }

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

  Future<void> sendImagesToApi(List<String> imageUrls) async {
    final String apiUrl =
        'https://gts-b8dycqbsc6fqd6hg.uaenorth-01.azurewebsites.net/api/Vendor/${user.vendorId}/business-images';

    // Create a list of UpdateBusinessImageDTO objects from the imageUrls list
    List<UpdateBusinessImageDTO> imageDTOList = [];

    for (int i = 0; i < imageUrls.length; i += 3) {
      imageDTOList.add(UpdateBusinessImageDTO(
        imgUrl1: imageUrls.length > i ? imageUrls[i] : '',
        imgUrl2: imageUrls.length > i + 1 ? imageUrls[i + 1] : '',
        imgUrl3: imageUrls.length > i + 2 ? imageUrls[i + 2] : '',
      ));
    }

    // Convert the list of DTOs to JSON
    List<Map<String, dynamic>> jsonDTOList =
        imageDTOList.map((dto) => dto.toJson()).toList();

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(jsonDTOList), // Send the list directly as the body
    );
    isLoading.value = false;

    if (response.statusCode == 200) {
      getVendorsById();
      print('Images uploaded successfully');
    } else {
      print('Failed to upload images: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }
}
