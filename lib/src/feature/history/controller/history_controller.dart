import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gens/src/core/api/api_services.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/injection_container.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/api/notification_controller.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/core/utils/snack_bar.dart';
import 'package:gens/src/feature/history/model/history_model.dart';
import 'package:gens/src/feature/history/model/user_waiting_model.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class HistoryController extends GetxController {
  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());
  final DioConsumer dioConsumer = sl<DioConsumer>();

  RxBool isLaoding = false.obs;
  RxInt selectedIndex = 0.obs;
  User user = User();

  RxList<History> filteredList = <History>[].obs;
  RxList<History> bookings = <History>[].obs;
  RxList<UserWaitingList> waitingList = <UserWaitingList>[].obs;
  final notificationController = Get.put(NotificationController());

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
        final response = await dioConsumer.get(
          "${EndPoints.getBooking}${user.userId.value}/details",
        );
        if (response.statusCode == StatusCode.ok) {
          final List<dynamic> jsonData = json.decode(response.data);

          List<History> servicesData =
              jsonData.map((json) => History.fromJson(json)).toList();

          bookings.value = servicesData;
          isLaoding.value = false;
        } else {
          bookings.value = [];
          isLaoding.value = false;
        }
      } catch (e) {
        print(e);
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

  Future<void> getWaitingList(context) async {
    if (await networkInfo.isConnected) {
      isLaoding.value = true;
      try {
        final response = await dioConsumer.get(
          "${EndPoints.addWaitingList}/user/${user.userId.value}",
        );

        if (response.statusCode == StatusCode.ok) {
          final List<dynamic> jsonData = json.decode(response.data);

          List<UserWaitingList> servicesData =
              jsonData.map((json) => UserWaitingList.fromJson(json)).toList();

          waitingList.value = servicesData;
          isLaoding.value = false;
        } else {
          bookings.value = [];
          isLaoding.value = false;
        }
      } catch (e) {
        print(e);
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

  Future<void> canceleBooking(int book, index, NotificationModel model) async {
    if (await networkInfo.isConnected) {
      var body =
          jsonEncode({'removeFromSchulde': false, 'newStatus': "Canceled"});
      await Future.delayed(const Duration(milliseconds: 600));
      final response = await dioConsumer.post(
        "${EndPoints.postBooking}/$book/status",
        body: body,
      );
      notificationController.sendNotification(model);
      print(response.data);
      // final response = await dioConsumer.delete(
      //   "${EndPoints.postBooking}/$book",
      // );
      if (response.statusCode == StatusCode.ok) {
        Get.back();
        filteredList.removeAt(index);

        showSnackBar("Success",
            "The reservation has been successfully deleted.", Colors.green);
      } else {
        showSnackBar("Error", "Error while deleting reservation", Colors.red);
      }
    }
  }
}
