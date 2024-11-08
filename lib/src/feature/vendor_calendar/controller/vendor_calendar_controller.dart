import 'dart:convert';

import 'package:calendar_view/calendar_view.dart';
import 'package:gens/src/core/api/api_services.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/injection_container.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/vendor_calendar/model/vendor_calendar_model.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class VendorCalendarController extends GetxController {
  final DioConsumer dioConsumer = sl<DioConsumer>();
  // Rx<CalendarView> currentView = CalendarView.month.obs;
  RxBool isDay = false.obs;

  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());
  RxBool isMonthView = true.obs;
  var selectedDate = DateTime.now().obs;
  EventController eventController = EventController();
  RxList<VendorCalendarModel> event = <VendorCalendarModel>[].obs;
  User user = User();

  @override
  void onInit() async {
    await user.loadToken();
    getCalenderForVendor();

    // Add test events to the list

    super.onInit();
  }

  Future<void> getCalenderForVendor() async {
    try {
      final response = await dioConsumer
          .get("${EndPoints.getVendorId}/${user.vendorId.value}/calendar");
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == 200) {
        final List<dynamic> evenData = json.decode(response.data);

        List<VendorCalendarModel> eventList =
            evenData.map((json) => VendorCalendarModel.fromJson(json)).toList();
        for (var x in eventList) {
          event.add(x);
        }
        // event.value = eventList;
      }
    } catch (e) {
      print(e);
    }
  }
}
