import 'dart:convert';

import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/booking/view/widget/collection/booking_success.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingController extends GetxController {
  CalendarFormat calendarFormat = CalendarFormat.month;
  final Rx<DateTime> focusedDay = DateTime.now().obs;
  final Rx<DateTime?> selectedDay = Rx<DateTime?>(null);

  // Use these date and time formats
  DateFormat dateFormat =
      DateFormat('yyyy-MM-dd'); // For date format: yyyy-MM-dd
  DateFormat timeFormat = DateFormat('HH:mm:ss'); // For time format: HH:mm:ss
  RxBool isLoading = false.obs;
  RxString hourSelected = "".obs;
  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());
  RxList<String> workingHors = <String>[].obs;
  final RxInt day = 0.obs;
  final RxInt month = 0.obs;
  final RxInt year = 0.obs;
  final RxString dayOfWeek = "".obs;
  // late List<DateTime> timeSlots;
  @override
  void onInit() {
    // timeSlots = generateTimeSlots();
    user.loadToken();
    user.vendorId();
    super.onInit();
  }

//add the start and end time from abdullah
  // List<DateTime> generateTimeSlots() {
  //   List<DateTime> slots = [];
  //   DateTime startTime = DateTime.now().copyWith(hour: 10, minute: 0);
  //   DateTime endTime = DateTime.now().copyWith(hour: 17, minute: 0);

  //   while (startTime.isBefore(endTime) || startTime.isAtSameMomentAs(endTime)) {
  //     slots.add(startTime);
  //     startTime = startTime.add(const Duration(hours: 1));
  //   }
  //   return slots;
  // }

  @override
  void onClose() {
    hourSelected.value = "";
    selectedDay.value = null;
    super.onClose();
  }

  User user = User();
  Future<void> postBooking(serviceId, vendorId, context) async {
    if (await networkInfo.isConnected) {
      try {
        // Parse the selected start time
        DateTime startTime = DateFormat('HH:mm:ss').parse(hourSelected.value);

        // Add 1 hour to the start time to calculate the end time
        DateTime endTime = startTime.add(const Duration(hours: 1));

        var body = jsonEncode({
          "userId": user.userId.value,
          "vendorId": vendorId,
          "serviceId": serviceId,
          "bookedTime": dateFormat
              .format(focusedDay.value), // Format the date as yyyy-MM-dd
          "startTime":
              hourSelected.value, // The selected time in HH:mm:ss format
          "endTime":
              timeFormat.format(endTime), // Format the end time as HH:mm:ss
          "status": "Pending"
        });

        final response = await http.post(Uri.parse(EndPoints.postBooking),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: body);

        if (response.statusCode == StatusCode.created) {
          successBookingDialog(context, focusedDay.value, hourSelected.value);
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

  Future<void> getBookingHour(day, vendorId) async {
    workingHors.clear();
    if (await networkInfo.isConnected) {
      isLoading.value = true;
      final response = await http
          .get(Uri.parse("${EndPoints.timeslotsForDay}/$vendorId/$day"));
      if (response.statusCode == StatusCode.ok) {
        final List<dynamic> jsonData = json.decode(response.body)['timeSlots'];

        // Casting jsonData to List<String>
        workingHors.value = jsonData.map((e) => e.toString()).toList();
        isLoading.value = false;
      } else {
        workingHors.value = [];
        isLoading.value = false;
      }
    }
  }
}
