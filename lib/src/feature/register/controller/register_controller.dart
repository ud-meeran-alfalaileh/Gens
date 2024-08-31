import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:gens/src/core/api/api_services.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/injection_container.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/feature/login/view/pages/login_page.dart';
import 'package:gens/src/feature/register/model/country_model.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RegisterController extends GetxController {
  final name = TextEditingController();
  final List<String> genderOptions = ['Male', 'Female', 'Prefer not to say'];

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
    getCountry();
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
    final phoneError = validatePhoneNumber(phoneNumber.text);
    final genderError = validGender();
    final countryError = validCountry();

    if (nameError != null) errors.add("- $nameError");
    if (phoneError != null) errors.add("- $phoneError");
    if (genderError != null) errors.add("- $genderError");
    if (countryError != null) errors.add("- $countryError");

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

  String removeLeadingZero(String input) {
    if (input.startsWith("962")) {
      return input.substring(3); // Remove "962"
    } else if (input.startsWith("0")) {
      return input.replaceFirst(RegExp('^0+'), '');
    }
    return input;
  }

  validConfirmPassword(String password) {
    if (password != this.password.text) {
      return "VaildConfirmPassword".tr;
    }
    return null;
  }

  Future<void> register(BuildContext context) async {
    bool isMounted = true;

    // Check if the context is still mounted before showing any SnackBars
    void showSnackBarIfMounted(Widget snackBar) {
      if (isMounted) {
        showTopSnackBar(Overlay.of(context), snackBar);
      }
    }

    if (await networkInfo.isConnected) {
      var body = {
        "name": name.text,
        "email": email.text,
        "phone": "962${removeLeadingZero(phoneNumber.text)}",
        "password": password.text,
        "password_confirmation": confirmPassword.text,
        "gender": selectedGender.value,
        'country_id': selectedCountry.value?.id
      };
      final response = await dioConsumer.post(EndPoints.signup, body: body);
      try {
        if (response.statusCode == StatusCode.ok ||
            response.statusCode == StatusCode.created) {
          final data = jsonDecode(response.data);
          if (data['success'] == false) {
            // Extract the error message
            final errorEmailMessage = data['error']?['email']?.first;
            final errorPhoneMessage = data['error']?['phone']?.first;
            String errorMessage = '';
            if (errorEmailMessage != null && errorPhoneMessage != null) {
              errorMessage = "لقد تم استخدام الهاتف والبريد الإلكتروني.";
            } else if (errorEmailMessage == null && errorPhoneMessage != null) {
              errorMessage = "لقد تم استخدام رقم الهاتف بالفعل.";
            } else if (errorEmailMessage != null && errorPhoneMessage == null) {
              errorMessage = "لقد تم استخدام البريد الإلكتروني بالفعل.";
            }
            // Show the error message in the SnackBar
            showSnackBarIfMounted(CustomSnackBar.error(
              message: errorMessage,
            ));
          } else {
            // Success case
            showSnackBarIfMounted(const CustomSnackBar.success(
              message: "تم تسجيلك بنجاح!",
            ));
            Get.offAll(const LoginPage());
          }
        } else {
          // Handle other status codes
          showSnackBarIfMounted(const CustomSnackBar.error(
            message: 'لقد حدث خطأ ما، حاول مرة أخرى',
          ));
        }
      } catch (e) {
        // Handle exception
        showSnackBarIfMounted(const CustomSnackBar.error(
          message: 'لقد حدث خطأ ما، حاول مرة أخرى',
        ));
      }
    }

    // Mark isMounted as false once the method is complete
    isMounted = false;
  }

  Future<void> getCountry() async {
    if (await networkInfo.isConnected) {
      final response = await dioConsumer.get(EndPoints.getCountry);
      if (response.statusCode == StatusCode.ok) {
        final List<dynamic> responseData =
            json.decode(response.data)['data']['Countries'];
        countries.value = responseData
            .map((countryData) => CountryModel.fromJson(countryData))
            .toList();
      }
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
