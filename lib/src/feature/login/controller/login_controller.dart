import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:gens/src/core/api/api_services.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/injection_container.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/nav_bar/view/main/navbar_page.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginController extends GetxController {
  final username = TextEditingController();
  final password = TextEditingController();

  RxBool unauthorized = false.obs;
  final DioConsumer dioConsumer = sl<DioConsumer>();
  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());

  //validation
  validUserName(String name) {
    if (name.isEmpty) {
      return "usernamePassword".tr;
    } else if (name.length < 5) {
      return "usernamePasswordLength".tr;
    }
    return null;
  }

  vaildEmail(String? email) {
    if (!GetUtils.isEmail(email!)) {
      return "EmailValidate".tr;
    }
    return null;
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
      try {
        final response = await dioConsumer.post(EndPoints.login, body: {
          "email": username.text,
          "password": password.text,
          'remember_me': 1,
        });
        if (response.statusCode == StatusCode.ok ||
            response.statusCode == StatusCode.created) {
          final jsonData = json.decode(response.data);
          final token = jsonData['access_token'];
          await user.saveToken(token);
          user.token.value = token;
          await user.loadToken();
          user.saveToken(token);
          await user.loadGoogleToken();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: "loginSuccess".tr,
            ),
          );
          Get.offAll(const NavBarPage());
          username.clear();
          password.clear();
        } else if (response.data['message'] == "Unauthorized") {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: 'loginError'.tr,
            ),
          );

          unauthorized.value = true;
        }
      } catch (e) {
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
