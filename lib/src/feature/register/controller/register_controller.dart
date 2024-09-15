import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gens/src/core/api/api_services.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/injection_container.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/forgtet_password/view/widget/main_widget/otp_widget.dart';
import 'package:gens/src/feature/login/view/pages/login_page.dart';
import 'package:gens/src/feature/nav_bar/view/main/main_app_page.dart';
import 'package:gens/src/feature/register/model/country_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RegisterController extends GetxController {
  final name = TextEditingController();
  final secName = TextEditingController();
  final List<String> genderOptions = ['Male', 'Female', 'Prefer not to say'];
  RxBool isLoading = false.obs;
  User user = User();
  RxInt remainingTime = 30.obs;
  RxBool isButtonEnabled = false.obs;
  // Initialize as null
  Rx<String?> selectedGender = Rx<String?>(null);

  // Selected country
  var selectedCountry = Rx<CountryModel?>(null);
  final RxInt currentPageIndex = 0.obs;
  final fromKeyOne = GlobalKey<FormState>();
  final fromKeyTwo = GlobalKey<FormState>();
  double get progress => currentPageIndex.value / 2;
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final DioConsumer dioConsumer = sl<DioConsumer>();
  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());
  late PageController pageController = PageController();
  RxList<CountryModel> countries = <CountryModel>[].obs;

  //validation
  vaildEmail(String? email) {
    if (!GetUtils.isEmail(email!)) {
      return "EmailValidate".tr;
    }
    return null;
  }

  void nextPage() {
    if (currentPageIndex.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      Get.offAll(const LoginPage());
    }
  }

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  vaildPassword(String? password) {
    if (!GetUtils.isLengthGreaterOrEqual(password, 8)) {
      return "PasswordValidation".tr;
    }
    return null;
  }

  validUserName(String name) {
    if (name.isEmpty) {
      return "nameValidation".tr;
    } else if (name.length < 5) {
      return "nameValidation".tr;
    }
    return null;
  }

  validsecName(String name) {
    if (name.isEmpty) {
      return "secNameValidation".tr;
    } else if (name.length < 5) {
      return "secNameValidation".tr;
    }
    return null;
  }

  validGender() {
    if (selectedGender.value == null) {
      return "slecetGender".tr;
    }
    return null;
  }

  validCountry() {
    if (selectedCountry.value == null) {
      return "slecetCountry".tr;
    }
    return null;
  }

  String? validatePhoneNumber(String? phoneNumber) {
    if (phoneNumber != null && phoneNumber.length >= 10) {
      if (GetUtils.isPhoneNumber(phoneNumber)) {
        return null;
      } else {
        return "phoneValidation".tr;
      }
    } else {
      return "phoneValidation".tr;
    }
  }

  String? pageOneValidateAllFields() {
    RxList<String?> errors = <String>[].obs;

    // Validate each form field and collect errors
    final nameError = validUserName(name.text);
    final secNameError = validsecName(secName.text);
    final phoneError = validatePhoneNumber(phoneNumber.text);
    final genderError = validGender();

    if (nameError != null) errors.add("- $nameError");
    if (secNameError != null) errors.add("- $secNameError");
    if (phoneError != null) errors.add("- $phoneError");
    if (genderError != null) errors.add("- $genderError");

    if (errors.isNotEmpty) {
      return errors.first;
    }
    return "valid";
  }

  RxString errorText = "".obs;
  String? validateAllFields() {
    RxList<String?> errors = <String>[].obs;

    // Validate each form field and collect errors
    final emailError = vaildEmail(email.text);
    final passwordError = vaildPassword(password.text);
    final confirmPasswordError = validConfirmPassword(confirmPassword.text);

    if (emailError != null) errors.add("- $emailError");
    if (passwordError != null) errors.add("- $passwordError");
    if (confirmPasswordError != null) errors.add("- $confirmPasswordError");

    if (errors.isNotEmpty) {
      return errors.first;
    }
    return "valid";
  }

  validConfirmPassword(String password) {
    if (password != this.password.text) {
      return "VaildConfirmPassword".tr;
    }
    return null;
  }

  String removeLeadingZero(String input) {
    if (input.startsWith("962")) {
      return input.substring(3); // Remove "962"
    } else if (input.startsWith("0")) {
      return input.replaceFirst(RegExp('^0+'), '');
    }
    return input;
  }

  Future<void> register(context) async {
    // Check if the context is still mounted before showing any SnackBars

    if (await networkInfo.isConnected) {
      var body = jsonEncode({
        "password": password.text.trim(),
        "email": email.text.trim(),
        "fName": name.text.trim(),
        "secName": secName.text.trim(),
        "phone": "962${removeLeadingZero(phoneNumber.text.trim())}",
        "gender": selectedGender.value,
        "userType": "User",
        "logined": true,
        "disable": true,
        "locked": true,
        "userImage": ""
      });
      final response = await http.post(Uri.parse(EndPoints.signup),
          headers: {
            'Content-Type':
                'application/json', // This should match the API's expected content type
            'Accept': 'application/json',
          },
          body: body);
      try {
        if (response.statusCode == StatusCode.ok ||
            response.statusCode == StatusCode.created) {
          final jsonData = json.decode(response.body);
          final token = jsonData['userId'];
          await user.saveId(token);
          user.userId.value = token;
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: "loginSuccess".tr,
            ),
          );
          isLoading.value = false;

          Get.offAll(const MainAppPage());
          phoneNumber.clear();
          password.clear();
        } else {}
      } catch (error) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: error.toString(),
          ),
        );
      }
    }

    // Mark isMounted as false once the method is complete
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

      Get.to(() => const OtpWidget());
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

  Future<void> checklOtp(String verificationCode, context) async {
    await user.loadOtp();
    isLoading.value = true;
    if (user.otpCode.value == verificationCode) {
      register(context);
    } else {
      isLoading.value = false;
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: 'Verification Code is not Correct',
        ),
      );
    }
  }

  @override
  void onClose() {
    name.dispose();
    email.dispose();
    phoneNumber.dispose();
    password.dispose();
    confirmPassword.dispose();
    pageController.dispose();
    super.onClose();
  }
}
