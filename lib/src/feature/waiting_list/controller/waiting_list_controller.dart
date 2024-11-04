import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/api/api_services.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/injection_container.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/api/notification_controller.dart';
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
  final notificationController = Get.put(NotificationController());

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
        : DateFormat('yyyy-MM-dd').format(rangeStartDay.value!);

    print(formattedStart);
    print(formattedEnd);
  }
 Future workingTime(BuildContext context, TextEditingController text) async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            // Customizing the color of the TimePicker
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              timeSelectorSeparatorColor:
                  WidgetStateColor.resolveWith((states) {
                return Colors.black; // Selected hour/minute text color
              }),
              dialBackgroundColor: Colors.black.withOpacity(0.1),
              dialHandColor: AppTheme.lightAppColors.primary, // Hand color
              dialTextColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white; // Selected hour color
                }
                return Colors.black; // Default hour color
              }),
              dayPeriodColor: AppTheme.lightAppColors.primary,
              dayPeriodTextColor: AppTheme.lightAppColors.mainTextcolor,

              hourMinuteColor: Colors.white,
              hourMinuteTextColor: AppTheme
                  .lightAppColors.primary, // Color of the selected time (hours)
            ),
          ),
          child: child!,
        );
      },
    );

    if (newTime != null) {
      final hour = newTime.hour;

      text.text = "$hour:00"; // Display only the hours with 00 minutes
    }
  }

  Future<void> addWaitingList(
      int vendorId, int serviceId, BuildContext context, vendorPhone) async {
    isLoading.value = true;

    if (await networkInfo.isConnected) {
      // Check if dates are empty
      if (formattedStart.value.isEmpty || formattedEnd.value.isEmpty) {
        Get.snackbar(
          "Error".tr,
          "Please select both start and end dates.".tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        isLoading.value = false;

        return;
      }

      // Check if start time and end time are empty
      if (startTime.text.isEmpty || endTime.text.isEmpty) {
        Get.snackbar(
          "Error".tr,
          "Please enter both start and end times.".tr,
          snackPosition: SnackPosition.BOTTOM,
        );
        isLoading.value = false;

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
            "Error".tr,
            "Start time cannot be greater than end time.".tr,
            snackPosition: SnackPosition.BOTTOM,
          );
          isLoading.value = false;

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
        print(response.data);
        if (response.statusCode == StatusCode.ok ||
            response.statusCode == StatusCode.created) {
          isLoading.value = false;
          waitingSuccess(context);
          notificationController.sendNotification(NotificationModel(
              title: "User Joined Waiting List",
              message:
                  "A user has joined the waiting list for an appointment. Please monitor the list and update availability as needed.",
              imageURL: "",
              externalIds: vendorPhone));
        }
        isLoading.value = false;

        print(response.data);
      } catch (e) {
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