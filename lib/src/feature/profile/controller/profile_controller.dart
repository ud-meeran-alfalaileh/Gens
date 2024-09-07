import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/profile/model/user_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileController extends GetxController {
  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());
  User user = User();
  RxInt userId = 0.obs;
  Rx<String?> imagefile = "".obs;
  RxBool isUpdating = false.obs;
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final name = TextEditingController();
  final secName = TextEditingController();

  Rx<UserModel?> userData = UserModel(
          userId: 0,
          password: "password",
          email: "email",
          fName: "fName",
          secName: "secName",
          phone: "phone",
          gender: "gender",
          userType: "userType",
          questionID: 0,
          userImagesID: 0,
          userImage: "")
      .obs;
  String removeLeadingZero(String input) {
    if (input.startsWith("962")) {
      return input.substring(3); // Remove "962"
    } else if (input.startsWith("0")) {
      return input.replaceFirst(RegExp('^0+'), '');
    }
    return input;
  }

  @override
  void onInit() async {
    super.onInit();
    await user.loadToken();
    userId.value = user.userId.value;
    await getUser(userId.value);
  }

  Future<void> getUser(id) async {
    final response = await http.get(
      Uri.parse("${EndPoints.getUser}/${userId.value}"),
      headers: {
        'Accept': 'application/json',
      },
    );

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == StatusCode.ok) {
      final data = jsonDecode(response.body);
      final responseData = UserModel.fromJson(data);
      userData.value = responseData;
      email.text = responseData.email;
      name.text = responseData.fName;
      secName.text = responseData.secName;
      phoneNumber.text = responseData.phone;
    }
  }

  Future<String?> uploadImageToFirebase(File pickedFile) async {
    try {
      // Create a reference to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images/${pickedFile.path.split('/').last}');

      await storageRef.putFile(pickedFile);

      // Get download URL
      String downloadURL = await storageRef.getDownloadURL();
      print(downloadURL);
      imagefile.value = downloadURL;
      await updateUserImage(downloadURL);

      return downloadURL;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  Future<void> pickImages() async {
    // await requestPermissions();

    try {
      PermissionStatus status = await Permission.storage.request();

      if (status.isGranted) {
        final pickedFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          File image = File(pickedFile.path);
          isUpdating.value = true;

          await uploadImageToFirebase(image);

          Get.back();
          isUpdating.value = false;
        }
      } else if (status.isDenied || status.isPermanentlyDenied) {
        openAppSettings();
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
        openAppSettings();
      }
      throw Exception('Error picking image: $e');
    }
  }

  Future<void> updateUserImage(downloadURL) async {
    if (await networkInfo.isConnected) {
      try {
        var body = jsonEncode(
            {"userId": user.userId.value.toString(), "userImage": downloadURL});

        final response = await http.post(Uri.parse(EndPoints.updateImage),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: body);
        print(response.body);
        print(response.statusCode);
        if (response.statusCode == StatusCode.ok) {
          getUser(userId);
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
