import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/doctor_profile/model/doctor_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class VendorProfileController extends GetxController {
  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());
  final name = TextEditingController();
  final userType = TextEditingController();
  final description = TextEditingController();
  final phone = TextEditingController();
  final location = TextEditingController();
  final image = TextEditingController();
  late Rx<DoctorModelById?> vendor = Rx<DoctorModelById?>(null);

  RxBool isLoading = false.obs;
  User user = User();
  @override
  void onInit() {
    user.loadVendorId();

    super.onInit();
  }

  Future<void> getVendorsById() async {
    isLoading.value = true;

    if (await networkInfo.isConnected) {
      try {
        final response = await http.get(
          Uri.parse("${EndPoints.getVendorId}/${user.vendorId}/details"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );
        print("{{{{{{id}}}}}}");
        print(user.vendorId);
        print("{{{{{{{{id}}}}}}}}");

        if (response.statusCode == StatusCode.ok) {
          try {
            final dynamic jsonData = json.decode(response.body);

            vendor.value = DoctorModelById.fromJson(jsonData);
            name.text = vendor.value!.name;
            location.text = vendor.value!.location;
            description.text = vendor.value!.description;
            phone.text = vendor.value!.phone;
            userType.text = vendor.value!.type;
            image.text = vendor.value!.businessImages.first.imgUrl1;
            isLoading.value = false;
          } catch (e) {
            Get.snackbar(
              "Error",
              "Failed to parse vendor data",
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        } else {
          Get.snackbar(
            "Error",
            "Failed to fetch vendors",
            snackPosition: SnackPosition.BOTTOM,
          );
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
}
