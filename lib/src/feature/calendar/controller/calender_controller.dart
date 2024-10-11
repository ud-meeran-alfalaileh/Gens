import 'dart:convert';

import 'package:calendar_view/calendar_view.dart';
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
    addTestEvents();

    super.onInit();
  }

  Future<void> getCalenderForUser() async {
    try {
      final response =
          await dioConsumer.get("${EndPoints.userCalender}${user.userId}");
      print(response.data);
      if (response.statusCode == 200) {
        final List<dynamic> evenData = json.decode(response.data);

        List<CalendarEvent> eventList =
            evenData.map((json) => CalendarEvent.fromJson(json)).toList();

        event.value = eventList;
        print("object${eventList.length}");
      }
    } catch (e) {
      print(e);
    }
  }

  // Test data for debugging
  void addTestEvents() {
    List<CalendarEvent> testEvents = [
      CalendarEvent(
        serviceName: 'Test Event 1',
        description: '..',
        vendorId: 1,
        vendorName: 'Vendor A',
        userId: 101,
        status: 'Pending',
        year: DateTime.now().year,
        month: DateTime.now().month,
        day: DateTime.now().day,
        date: DateTime.now(),
      ),
    ];

    event.addAll(testEvents);
  }
}
