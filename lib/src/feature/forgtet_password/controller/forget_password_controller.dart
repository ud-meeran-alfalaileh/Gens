import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/core/utils/snack_bar.dart';
import 'package:gens/src/feature/forgtet_password/view/page/forget_password_page.dart';
import 'package:gens/src/feature/forgtet_password/view/widget/main_widget/forget_passwrod_page.dart';
import 'package:gens/src/feature/forgtet_password/view/widget/main_widget/passwor_otp.dart';
import 'package:gens/src/feature/login/view/pages/login_page.dart';
import 'package:gens/src/feature/show_user/controller/show_user_controller.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ForgetPasswordController extends GetxController {
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  RxInt remainingTime = 30.obs;
  RxBool isLoading = false.obs;
  RxBool isExist = false.obs;
  final fromKeyOne = GlobalKey<FormState>();
  RxString nEmail = "".obs;
  Future<void> checklOtp(String verificationCode, context) async {
    await user.loadOtp();
    isLoading.value = true;
    if (user.otpCode.value == verificationCode) {
      Get.to(() => const ForgetPasswrodForm());
    } else {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: 'Verification Code is not Correct',
        ),
      );
    }
    isLoading.value = false;
  }

  User user = User();
  vaildPassword(String? password) {
    if (!GetUtils.isLengthGreaterOrEqual(password, 6)) {
      return "PasswordValidation".tr;
    }
    return null;
  }

  validConfirmPassword(String password) {
    if (password != this.password.text) {
      return "VaildConfirmPassword".tr;
    }
    return null;
  }

  Future<void> checkExist() async {
    var body = '"${nEmail.value}"'; // Ensure the email is a string with quotes
    final response = await dioConsumer.post(EndPoints.checkExist, body: body);

    if (response.statusCode == StatusCode.ok) {
      final data = jsonDecode(response.data)['userExits'];
      isExist.value = data;
    }
  }

  Future<void> sendEmail(context) async {
    isLoading.value = true;

    await checkExist();
    if (isExist.value) {
      await user.clearOtp();
      var body = jsonEncode({
        "email": email.text.trim(),
        "subject": "Access code",
        "message": "otp"
      });
      final response = await dioConsumer.post(EndPoints.senMessage, body: body);
      if (response.statusCode == StatusCode.ok) {
        final jsonData = json.decode(response.data);
        final otpId = jsonData['randomNumber'];
        await user.saveOtp(otpId.toString());
        await user.loadOtp();
        isLoading.value = false;

        Get.to(() => const PassworOtp());
      } else {
        isLoading.value = false;

        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(
            message: 'Something went wrong.',
          ),
        );
        isLoading.value = false;
      }
    } else {
      isLoading.value = false;

      showSnackBar("Email does not exist.", "Error", Colors.red);
    }
  }

  Future<void> resetPassword() async {
    isLoading.value = true;
    try {
      var body =
          jsonEncode({"email": nEmail.value, "password": password.text.trim()});

      final response =
          await dioConsumer.post(EndPoints.resetPassword, body: body);

      if (response.statusCode == StatusCode.ok) {
        showSnackBar("Password changed successfully \n try login now",
            "Success", Colors.green);
        Get.offAll(() => const LoginPage());
      } else {
        showSnackBar("Error", "Please cheack you email", Colors.red);
        Get.offAll(() => const ForgetPasswordPage());
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
  }

  RxBool isButtonEnabled = false.obs;
  final fromKey = GlobalKey<FormState>();
  String? pageOneValidateAllFields() {
    RxList<String?> errors = <String>[].obs;
    vaildEmail(String? email) {
      if (!GetUtils.isEmail(email!)) {
        return "EmailValidate".tr;
      }
      return null;
    }

    // Validate each form field and collect errors
    final nameError = vaildEmail(email.text);

    if (nameError != null) errors.add("- $nameError");

    if (errors.isNotEmpty) {
      return errors.first;
    }
    return "valid";
  }

  RxString errorText = "".obs;
}
