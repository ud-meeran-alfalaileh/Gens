import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/login/view/pages/login_page.dart';
import 'package:gens/src/feature/profile/model/user_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ProfileController extends GetxController {
  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());
  User user = User();
  RxInt userId = 0.obs;
  final passwordFromKey = GlobalKey<FormState>();
  RxString errorText = "".obs;

  Rx<String?> imagefile = "".obs;
  RxBool isUpdating = false.obs;
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final password = TextEditingController();

  final oldPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();
  final name = TextEditingController();
  final secName = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isLoadingImg = false.obs;
  Rx<String?> selectedGender = Rx<String?>(null);
  final List<String> genderOptions = ['Male', 'Female', 'Prefer not to say'];

  Rx<UserModel?> userData = UserModel(
          userId: 0,
          password: "password",
          email: "email",
          fName: "fName",
          secName: "secName",
          phone: "phone",
          gender: "gender",
          userType: "userType",
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
    await user.loadToken();
    userId.value = user.userId.value;
    super.onInit();
  }

  Future<void> getUser(id, context) async {
    if (await networkInfo.isConnected) {
      isLoading.value = true;
      try {
        final response = await http.get(
          Uri.parse("${EndPoints.getUser}/${userId.value}"),
          headers: {
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == StatusCode.ok) {
          isLoading.value = false;

          final data = jsonDecode(response.body);
          final responseData = UserModel.fromJson(data);
          userData.value = responseData;
          email.text = responseData.email;
          name.text = responseData.fName;
          secName.text = responseData.secName;
          phoneNumber.text = responseData.phone;
          // selectedGender.value = responseData.g
        } else {}
      } catch (e) {
        isLoading.value = false;
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

  Future<void> updateUser(context) async {
    if (await networkInfo.isConnected) {
      isLoading.value = true;
      var body = jsonEncode({
        "email": email.text.trim(),
        "fName": name.text.trim(),
        "secName": secName.text.trim(),
        "phone": "962${removeLeadingZero(phoneNumber.text.trim())}",
        "gender": selectedGender.value
      });
      try {
        final response =
            await http.put(Uri.parse("${EndPoints.getUser}/${userId.value}"),
                headers: {
                  'Accept': 'application/json',
                  'Content-Type': 'application/json',
                },
                body: body);

        if (response.statusCode == StatusCode.ok) {
          isLoading.value = false;

          getUser(user.userId, context);
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

  vaildoldPassword(String? password) {
    if (!GetUtils.isLengthGreaterOrEqual(password, 8)) {
      return "PasswordOldValidation".tr;
    }
    return null;
  }

  vaildNewPassword(String? password) {
    if (!GetUtils.isLengthGreaterOrEqual(password, 8)) {
      return "PasswordNewValidation".tr;
    }
    return null;
  }

  validConfirmPassword(String password) {
    if (password != newPassword.text) {
      return "VaildConfirmPassword".tr;
    }
    return null;
  }

  Future<String?> uploadImageToFirebase(File pickedFile, context) async {
    try {
      // Create a reference to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('user_images/${pickedFile.path.split('/').last}');

      await storageRef.putFile(pickedFile);

      // Get download URL
      String downloadURL = await storageRef.getDownloadURL();
      imagefile.value = downloadURL;
      await updateUserImage(downloadURL, context);

      return downloadURL;
    } catch (e) {
      return null;
    }
  }

  Future<void> pickImages(context) async {
    isLoadingImg.value = true;
    try {
      PermissionStatus status = await Permission.storage.request();

      if (status.isGranted) {
        final pickedFile =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          File image = File(pickedFile.path);
          isUpdating.value = true;

          await uploadImageToFirebase(image, context);

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

  Future<void> updateUserImage(downloadURL, context) async {
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
        if (response.statusCode == StatusCode.ok) {
          getUser(userId, context);
        }
        isLoadingImg.value = false;
      } catch (e) {
        print(e);
      }
      isLoadingImg.value = false;
    }
  }

  String? validateAllFields() {
    RxList<String?> errors = <String>[].obs;

    // Validate each form field and collect errors
    final oldPasswordError = vaildoldPassword(oldPassword.text);
    final passwordError = vaildNewPassword(newPassword.text);
    final confirmPasswordError = validConfirmPassword(confirmPassword.text);

    if (oldPasswordError != null) errors.add("- $oldPasswordError");
    if (passwordError != null) errors.add("- $passwordError");
    if (confirmPasswordError != null) errors.add("- $confirmPasswordError");

    if (errors.isNotEmpty) {
      return errors.first;
    }
    return "valid";
  }

  Future<void> updtaePassword(context) async {
    if (await networkInfo.isConnected) {
      isLoading.value = true;
      var body = jsonEncode({
        "currentPassword": oldPassword.text.trim(),
        "newPassword": newPassword.text.trim()
      });
      try {
        final response = await http.post(
            Uri.parse("${EndPoints.getUser}/${userId.value}/change-password"),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: body);

        if (response.statusCode == StatusCode.ok) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: 'Password changed successfully.'.tr,
            ),
          );
          isLoading.value = false;
        } else {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: 'Current password is incorrect'.tr,
            ),
          );
        }
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

  void logout() async {
    await user.clearId();
    Get.off(() => const LoginPage());
  }
}
