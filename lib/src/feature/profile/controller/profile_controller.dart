import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gens/src/core/api/api_services.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/injection_container.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/core/utils/snack_bar.dart';
import 'package:gens/src/feature/login/view/pages/login_page.dart';
import 'package:gens/src/feature/profile/model/question_model.dart';
import 'package:gens/src/feature/profile/model/user_model.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ProfileController extends GetxController {
  final DioConsumer dioConsumer = sl<DioConsumer>();

  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());
  User user = User();
  RxInt userId = 0.obs;
  final passwordFromKey = GlobalKey<FormState>();
  RxString errorText = "".obs;
  Rx<SkinCareModel?> question = Rx<SkinCareModel?>(null);
  Rx<String?> imagefile = "".obs;
  RxBool isUpdating = false.obs;
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final password = TextEditingController();
  final dateOfBirth = TextEditingController();

  final oldPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();
  final name = TextEditingController();
  final secName = TextEditingController();
  RxBool isUserLoading = false.obs;
  RxBool isSkinLoading = true.obs;
  // RxBool isLoading = false.obs;
  RxBool isLoadingImg = false.obs;
  Rx<String?> selectedGender = Rx<String?>(null);
  final List<String> genderOptions = ['Male', 'Female', 'Prefer not to say'];
  RxInt selectedIndex = 0.obs;
  RxBool buildProfile = false.obs;

  Rx<UserModel?> userData = UserModel(
          userId: 0,
          dateOfBirth: "password",
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

  void setSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  @override
  void onInit() async {
    await user.loadToken();
    userId.value = user.userId.value;
    await getUser(user.userId);
    await getQuestionDetails().whenComplete(() => isSkinLoading.value == false);
    super.onInit();
  }

  Future<void> getUser(
    id,
  ) async {
    if (await networkInfo.isConnected) {
      isUserLoading.value = true;
      try {
        final response = await dioConsumer.get(
          "${EndPoints.getUser}/${userId.value}",
        );

        if (response.statusCode == StatusCode.ok) {
          isUserLoading.value = false;
          final data = jsonDecode(response.data);
          final responseData = UserModel.fromJson(data);
          final ageDate = calculateAge(responseData.dateOfBirth);

          userData.value = responseData;
          email.text = responseData.email;
          name.text = responseData.fName;
          dateOfBirth.text = ageDate.toString();
          secName.text = responseData.secName;
          phoneNumber.text = responseData.phone;
          selectedGender.value = responseData.gender;
        } else {}
      } catch (e) {
        isUserLoading.value = false;
      }
    } else {
      isUserLoading.value = false;

      // showTopSnackBar(
      //   Overlay.of(context),
      //   CustomSnackBar.error(
      //     message: 'No Internet Connection'.tr,
      //   ),
      // );
    }
  }

  int calculateAge(String dateOfBirth) {
    DateTime birthDate = DateTime.parse(dateOfBirth);
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;

    // Adjust the age if the birthday hasn't occurred yet this year
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  Future<void> updateUser(context) async {
    if (await networkInfo.isConnected) {
      isUserLoading.value = true;
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
          isUserLoading.value = false;
          showSnackBar("Success", "Data Updated Successfully", Colors.green);
          getUser(user.userId);
        } else {}
      } catch (e) {
        isUserLoading.value = false;
      }
    } else {
      isUserLoading.value = false;

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
      isLoadingImg.value = true;

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
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File image = File(pickedFile.path);
        isUpdating.value = false;
        Get.back();

        await uploadImageToFirebase(image, context);

        isUpdating.value = false;
      }
    } catch (e) {
      isUpdating.value = false;

      if (Get.isDialogOpen ?? false) {
        Get.back();
        openAppSettings();
      }
      throw Exception('Error picking image: $e');
    }
  }

  Future<void> takeImages(context) async {
    // await requestPermissions();

    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        File image = File(pickedFile.path);
        isUpdating.value = false;

        await uploadImageToFirebase(image, context);

        Get.back();
        isUpdating.value = false;
      }
    } catch (e) {
      isUpdating.value = false;

      if (Get.isDialogOpen ?? false) {
        Get.back();
        isUpdating.value = false;

        openAppSettings();
      }
    }
  }

  Future<void> updateUserImage(downloadURL, context) async {
    if (await networkInfo.isConnected) {
      try {
        var body = jsonEncode(
            {"userId": user.userId.value.toString(), "userImage": downloadURL});

        final response =
            await dioConsumer.post(EndPoints.updateImage, body: body);
        if (response.statusCode == StatusCode.ok) {
          getUser(
            userId,
          );
        }
        isLoadingImg.value = false;
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
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
      isUserLoading.value = true;
      var body = jsonEncode({
        "currentPassword": oldPassword.text.trim(),
        "newPassword": newPassword.text.trim()
      });
      try {
        final response = await dioConsumer.post(
            "${EndPoints.getUser}/${userId.value}/change-password",
            body: body);

        if (response.statusCode == StatusCode.ok) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: 'Password changed successfully.'.tr,
            ),
          );
          isUserLoading.value = false;
        } else {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: 'Current password is incorrect'.tr,
            ),
          );
        }
      } catch (e) {
        isUserLoading.value = false;
      }
    } else {
      isUserLoading.value = false;

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
    OneSignal.logout();
    Get.off(() => const LoginPage());
  }

  late RxBool isFirstDataIncomplete = false.obs;
  late RxBool isSecDataIncomplete = false.obs;
  late RxBool isThirdDataIncomplete = false.obs;
  late RxBool isFourthDataIncomplete = false.obs;
  late RxBool isFifthDataIncomplete = false.obs;
  Future<void> getQuestionDetails() async {
    if (await networkInfo.isConnected) {
      isSkinLoading.value = true;
      try {
        final response = await dioConsumer.get(
            "https://gts-b8dycqbsc6fqd6hg.uaenorth-01.azurewebsites.net/api/Questionnaire/${user.userId}");

        if (response.statusCode == StatusCode.ok) {
          final data = jsonDecode(response.data);

          question.value = SkinCareModel.fromJson(data);
          isFirstDataIncomplete.value = ((question.value == null) ||
              question.value!.skinTypeMorning.isEmpty ||
              question.value!.skinConcerns == "" ||
              question.value!.skinIssue == "");
          isSecDataIncomplete.value = ((question.value == null) ||
              question.value!.maritalStatus.isEmpty ||
              question.value!.foodConsume.isEmpty ||
              question.value!.issuesFrequentlyExperience.isEmpty);
          isThirdDataIncomplete.value = ((question.value == null) ||
              question.value!.waterConsume == "" ||
              question.value!.exerciseRoutine == "" ||
              question.value!.stressLevel == "" ||
              question.value!.manageStress == "");
          print(question.value!.mainSkincareGoals);
          isFourthDataIncomplete.value = ((question.value == null) ||
              question.value!.mainSkincareGoals == "");
          print(isFourthDataIncomplete.value);
          isFifthDataIncomplete.value =
              ((question.value == null) || question.value!.b12Pills == "");
          print("kfkfkfkfkfkfkf : $isFifthDataIncomplete");
        } else {
          isFirstDataIncomplete.value = true;
          isSecDataIncomplete.value = true;
          isThirdDataIncomplete.value = true;
          isFourthDataIncomplete.value = true;
          isFifthDataIncomplete.value = true;
          final data = jsonDecode(response.data)['message'];
          if (data == "Questionnaire not found for the given user.") {
            buildProfile.value = true;
          }
        }

        isSkinLoading.value = F;
      } catch (e) {
        print(e);
      }
    }
  }
}
