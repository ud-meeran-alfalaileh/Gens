import 'dart:convert';

import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/foundation.dart';
import 'package:gens/src/core/api/api_services.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/injection_container.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/calendar/model/calender_model.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class CalenderControllerr extends GetxController {
  final DioConsumer dioConsumer = sl<DioConsumer>();
  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());
  RxBool isMonthView = true.obs;
  var selectedDate = DateTime.now().obs;
  EventController eventController = EventController();
  RxList<CalendarEvent> event = <CalendarEvent>[].obs;
  User user = User();

  @override
  void onInit() async {
    await user.loadToken();
    getCalenderForUser();

    // Add test events to the list

    super.onInit();
  }

  Future<void> getCalenderForUser() async {
    try {
      final response =
          await dioConsumer.get("${EndPoints.userCalender}${user.userId}");
      if (response.statusCode == 200) {
        final List<dynamic> evenData = json.decode(response.data);

        List<CalendarEvent> eventList =
            evenData.map((json) => CalendarEvent.fromJson(json)).toList();

        event.value = eventList;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // Test data for debugging
}
