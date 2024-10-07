import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gens/src/core/api/api_services.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/injection_container.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/nav_bar/view/main/main_app_page.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginController extends GetxController {
  final phoneNumber = TextEditingController();
  final password = TextEditingController();
  RxBool isLoading = false.obs;

  RxBool unauthorized = false.obs;
  final DioConsumer dioConsumer = sl<DioConsumer>();
  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());

  //validation
  String removeLeadingZero(String input) {
    if (input.startsWith("962")) {
      return input.substring(3); // Remove "962"
    } else if (input.startsWith("0")) {
      return input.replaceFirst(RegExp('^0+'), '');
    }
    return input;
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

  vaildPassword(String? password) {
    if (!GetUtils.isLengthGreaterOrEqual(password, 8)) {
      return "PasswordValidation".tr;
    }
    return null;
  }

  User user = User();
  Future<void> login(context) async {
    if (await networkInfo.isConnected) {
      isLoading.value = true;
      try {
        final body = jsonEncode({
          "phone": "962${removeLeadingZero(phoneNumber.text.trim())}",
          "password": password.text.trim(),
        });
        final response = await dioConsumer.post(EndPoints.login, body: body);

        if (response.statusCode == StatusCode.ok) {
          final jsonData = json.decode(response.data);
          final type = jsonData['userType'];
          if (type == 'User') {
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
          } else {
            final jsonData = json.decode(response.data);
            final token = jsonData['vendorId'];
            await user.saveVendorId(token);
            user.vendorId.value = token;
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
          }
        } else {
          isLoading.value = false;

          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: 'loginError'.tr,
            ),
          );

          unauthorized.value = true;
        }
      } catch (e) {
        isLoading.value = false;
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: 'loginError'.tr,
          ),
        );
        unauthorized.value = true;
      }
    }
  }
}
