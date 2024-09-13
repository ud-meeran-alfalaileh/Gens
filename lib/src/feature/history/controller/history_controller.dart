import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/core/utils/snack_bar.dart';
import 'package:gens/src/feature/history/model/history_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class HistoryController extends GetxController {
  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());
  RxBool isLaoding = false.obs;
  RxInt selectedIndex = 0.obs;
  User user = User();

  RxList<History> filteredList = <History>[].obs;
  RxList<History> bookings = <History>[].obs;

  void getFilteredList(int index) {
    filteredList.clear();
    if (index == 0) {
      filteredList.value = bookings
          .where((appointment) => appointment.status == 'Pending')
          .toList();
    } else if (index == 1) {
      filteredList.value = bookings
          .where((appointment) => appointment.status == 'Upcoming')
          .toList();
    } else if (index == 2) {
      filteredList.value = bookings
          .where((appointment) => appointment.status == 'Done')
          .toList();
    } else {
      bookings;
    }
  }

  Future<void> getBooking(context) async {
    if (await networkInfo.isConnected) {
      isLaoding.value = true;
      try {
        final response = await http.get(
          Uri.parse("${EndPoints.getBooking}${user.userId.value}/details"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == StatusCode.ok) {
          final List<dynamic> jsonData = json.decode(response.body);

          List<History> servicesData =
              jsonData.map((json) => History.fromJson(json)).toList();

          bookings.value = servicesData;
          isLaoding.value = false;
        } else {
          Get.snackbar(
            "Error Accure While Booking",
            "Try again later",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        Get.snackbar(
          "Error Accure While Booking",
          "Try again later",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.snackbar(
        "No Internet Connection",
        "Please check your network settings",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> canceleBooking(int book, index) async {
    if (await networkInfo.isConnected) {
      final response = await http.delete(
        Uri.parse(
          "${EndPoints.postBooking}/$book",
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == StatusCode.noContent) {
        Get.back();
        filteredList.remove(index);

        showSnackBar("Success",
            "The reservation has been successfully deleted.", Colors.green);
      } else {
        showSnackBar("Error", "Error while deleting reservation", Colors.red);
      }
    }
  }
}
