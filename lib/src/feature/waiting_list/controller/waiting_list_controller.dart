import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gens/src/core/api/api_services.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/injection_container.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/waiting_list/view/widget/collection/success_dialog.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart'; // Importing intl package
import 'package:table_calendar/table_calendar.dart';

class WaitingListController extends GetxController {
  final DioConsumer dioConsumer = sl<DioConsumer>();
  final Rx<DateTime> focusedDay = DateTime.now().obs;
  CalendarFormat calendarFormat = CalendarFormat.month;
  final Rx<DateTime?> selectedDay = Rx<DateTime?>(null);
  final RxString dayOfWeek = "".obs;
  var rangeStartDay = Rxn<DateTime>(); // Start of the selected date range
  var rangeEndDay = Rxn<DateTime>(); // End of the selected date range
  var rangeSelectionMode =
      RangeSelectionMode.toggledOn.obs; // Toggle for range selection
  RxBool isLoading = false.obs;
  RxString formattedStart = "".obs;
  RxString formattedEnd = "".obs;
  RxString hourSelected = "".obs;
  RxList<String> workingHours = <String>[].obs;
  final description = TextEditingController();
  final startTime = TextEditingController();
  final endTime = TextEditingController();
  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());

  User user = User();
  @override
  void onInit() {
    // timeSlots = generateTimeSlots();
    user.loadToken();

    super.onInit();
  }

  void setDateValue() {
    // Formatting the dates before printing
    formattedStart.value = rangeStartDay.value != null
        ? DateFormat('yyyy-MM-dd').format(rangeStartDay.value!)
        : '';
    formattedEnd.value = rangeEndDay.value != null
        ? DateFormat('yyyy-MM-dd').format(rangeEndDay.value!)
        : '';

    print(formattedStart);
    print(formattedEnd);
  }

  Future<void> addWaitingList(
      int vendorId, int serviceId, BuildContext context) async {
    isLoading.value = true;

    if (await networkInfo.isConnected) {
      // Check if dates are empty
      if (formattedStart.value.isEmpty || formattedEnd.value.isEmpty) {
        Get.snackbar(
          "Input Error",
          "Please select both start and end dates.",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Check if start time and end time are empty
      if (startTime.text.isEmpty || endTime.text.isEmpty) {
        Get.snackbar(
          "Input Error",
          "Please enter both start and end times.",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      try {
        // Parse start and end times with added seconds
        final startTimeValue =
            DateFormat('HH:mm').parse("${startTime.text.trim()}:00");
        final endTimeValue =
            DateFormat('HH:mm').parse("${endTime.text.trim()}:00");

        // Check if start time is after end time
        if (startTimeValue.isAfter(endTimeValue)) {
          Get.snackbar(
            "Input Error",
            "Start time cannot be greater than end time.",
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        // Format start and end times to HH:mm:ss
        final formattedStartTime =
            DateFormat('HH:mm:ss').format(startTimeValue);
        final formattedEndTime = DateFormat('HH:mm:ss').format(endTimeValue);

        // Proceed if validations pass
        var body = jsonEncode({
          "serviceId": serviceId,
          "vendorId": vendorId,
          "userId": user.userId.value,
          "startTime": formattedStartTime,
          "endTime": formattedEndTime,
          "startDate": formattedStart.value,
          "endDate": formattedEnd.value,
          "message": description.text,
          "status": "Waiting"
        });
        print(body);

        final response =
            await dioConsumer.post(EndPoints.addWaitingList, body: body);

        if (response.statusCode == StatusCode.ok) {
          isLoading.value = false;
          waitingSuccess(context);
        }
        print(response.data);
      } catch (e) {
        Get.snackbar(
          "Format Error",
          "Please enter a valid time in HH:mm format.",
          snackPosition: SnackPosition.BOTTOM,
        );
        print(e); // For debugging purposes
      }
    } else {
      Get.snackbar(
        "Network Error",
        "No internet connection. Please try again later.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
//