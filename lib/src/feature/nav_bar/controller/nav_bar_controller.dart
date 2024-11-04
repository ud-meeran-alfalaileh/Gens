import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gens/src/core/api/api_services.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/injection_container.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/login/view/pages/login_page.dart';
import 'package:gens/src/feature/register_vendor/view/widget/collection/register_page_four.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class NavController extends GetxController {
  final DioConsumer dioConsumer = sl<DioConsumer>();
  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());
  RxInt selectedIndex = 0.obs;
  final PageController pageController = PageController(initialPage: 0);
  RxBool isLoading = false.obs;
  RxBool status = true.obs;
  RxBool haveTime = false.obs;
  User user = User();
  @override
  Future<void> onInit() async {
    await user.loadVendorId();
    setSelectedIndex(0);
    super.onInit();
  }

  void logout() async {
    await user.clearVendorId();
    OneSignal.logout();

    Get.offAll(() => const LoginPage());
  }

  void setSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  Future<void> getVendorsById() async {
    isLoading.value = true;

    if (await networkInfo.isConnected) {
      try {
        final response =
            await dioConsumer.get("${EndPoints.getVendorId}/${user.vendorId}");

        if (response.statusCode == StatusCode.ok) {
          try {
            final dynamic jsonData = json.decode(response.data);

            final vendorDetails = jsonData['status'];

            status.value = vendorDetails;

            isLoading.value = false;
          } catch (e) {
            print(e);
          }
        } else {
          isLoading.value = false;
        }
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

  Future<void> getVendorsWorkingTime() async {
    isLoading.value = true;

    if (await networkInfo.isConnected) {
      try {
        final response = await dioConsumer
            .get("${EndPoints.getVendorId}/${user.vendorId}/details");

        if (response.statusCode == StatusCode.ok) {
          try {
            final dynamic jsonData = json.decode(response.data);

            final workingDetails = jsonData['workingTime'];
            if (workingDetails == "Not Available") {
              Get.offAll(() => const RegisterPageFour());
            } else {
              haveTime.value = false;
            }

            isLoading.value = false;
          } catch (e) {
            print(e);
          }

          isLoading.value = false;
        } else {}
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
}
