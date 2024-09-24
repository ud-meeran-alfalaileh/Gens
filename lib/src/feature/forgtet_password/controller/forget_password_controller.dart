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
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class ForgetPasswordController extends GetxController {
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  RxInt remainingTime = 30.obs;
  RxBool isLoading = false.obs;
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

  Future<void> sendEmail(context) async {
    isLoading.value = true;
    await user.clearOtp();
    var body = jsonEncode({
      "email": email.text.trim(),
      "subject": "Access code",
      "message": "otp"
    });
    final response = await http.post(Uri.parse(EndPoints.senMessage),
        headers: {
          'Content-Type':
              'application/json', // This should match the API's expected content type
          'Accept': 'application/json',
        },
        body: body);
    print(response.body);
    if (response.statusCode == StatusCode.ok) {
      final jsonData = json.decode(response.body);
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
  }

  Future<void> resetPassword() async {
    isLoading.value = true;
    try {
      var body =
          jsonEncode({"email": nEmail.value, "password": password.text.trim()});
      print(body);
      print(nEmail.value);
      final response = await http.post(
          Uri.parse(
              'https://gts-b8dycqbsc6fqd6hg.uaenorth-01.azurewebsites.net/reset-password'),
          headers: {
            'Content-Type':
                'application/json', // This should match the API's expected content type
            'Accept': 'application/json',
          },
          body: body);

      print(response.statusCode);
      print(response.body);
      print(body);
      if (response.statusCode == StatusCode.ok) {
        showSnackBar("Password changed successfully \n try login now",
            "Success", Colors.green);
        Get.offAll(() => LoginPage());
      } else {
        showSnackBar("Error", "Please cheack you email", Colors.red);
        Get.offAll(() => const ForgetPasswordPage());
      }
      isLoading.value = false;
    } catch (e) {
      print(e);
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

  // Future<void> updatePassword ()async{
  //   final response  = await http.post(url)
  // }
}
