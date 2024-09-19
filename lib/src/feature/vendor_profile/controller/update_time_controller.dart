import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/nav_bar/view/main/main_app_page.dart';
import 'package:gens/src/feature/register_vendor/model/schaduale_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class UpdateTimeController extends GetxController {
  RxBool isUpdating = false.obs;

  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());
  RxList<Schedule> schedules = <Schedule>[].obs;

  List<String> allDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  var selectedDays = <String>[].obs;

  TextEditingController operHour = TextEditingController();
  final TextEditingController closeHour = TextEditingController();
  User user = User();
  @override
  Future<void> onInit() async {
    super.onInit();
    await user.loadVendorId();

    getWorkingHours(); // Fetch data from API when the page is opened
  }

  // Function to toggle the day selection
  void toggleDaySelection(String day) {
    if (selectedDays.contains(day)) {
      selectedDays.remove(day); // Remove if already selected
    } else {
      selectedDays.add(day); // Add if not selected
    }
  }

  Future workingTime(BuildContext context, TextEditingController text) async {
    TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            timePickerTheme: TimePickerThemeData(
              dialHandColor: AppTheme.lightAppColors.primary,
              dialTextColor: WidgetStateColor.resolveWith((states) {
                return states.contains(WidgetState.selected)
                    ? Colors.white
                    : Colors.black;
              }),
            ),
          ),
          child: child!,
        );
      },
    );

    if (newTime != null) {
      text.text =
          "${newTime.hour}:${newTime.minute.toString().padLeft(2, '0')}";
    }
  }

  Future<void> getWorkingHours() async {
    try {
      isUpdating(true);
      final response = await http.get(
        Uri.parse("${EndPoints.getSchadule}${user.vendorId}"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        // Parsing the response as a Map
        final apiData = jsonDecode(response.body);

        // Extract the working days and pre-select them
        List<dynamic> workingDaysFromApi = apiData['workingDay'];
        selectedDays.assignAll(workingDaysFromApi.cast<String>());

        // Extract the working hours and split them into open and close time
        String workingHour = apiData['workingHour'];
        List<String> hours = workingHour.split(' - ');
        if (hours.length == 2) {
          operHour.text = hours[0]; // Opening hour
          closeHour.text = hours[1]; // Closing hour
        }
      } else {
        Get.snackbar("Error", "Failed to load working hours");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred while fetching data.");
    } finally {
      isUpdating(false);
    }
  }

  RxString jsonString = "".obs;

  Future<void> postSchedule() async {
    isUpdating.value = true;
    if (await networkInfo.isConnected) {
      for (var schedule in schedules) {
        // Convert Schedule object to JSON string
        String jsonString = jsonEncode(schedule.toJson());

        final response = await http.put(
          Uri.parse(
              'https://gts-b8dycqbsc6fqd6hg.uaenorth-01.azurewebsites.net/api/Schedule/UpdateWorkingDay/5'),
          headers: {
            'Content-Type': 'application/json', // API expects JSON
            'Accept': 'application/json',
          },
          body: jsonString, // Sending the JSON string
        );
        print(jsonString);
        print(response.body);
        print(response.statusCode);
        // Print response

        await Future.delayed(const Duration(milliseconds: 500));
      }
      isUpdating.value = false;
      Get.to(() => const MainAppPage());
    }
  }
}
