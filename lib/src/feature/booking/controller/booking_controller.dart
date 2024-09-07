import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingController extends GetxController {
  CalendarFormat calendarFormat = CalendarFormat.month;
  final Rx<DateTime> focusedDay = DateTime.now().obs;
  final Rx<DateTime?> selectedDay = Rx<DateTime?>(null);
  DateFormat timeFormat = DateFormat.jm();
  RxString hourSelected = "".obs;

  // Variables to store day, month, and year
  final RxInt day = 0.obs;
  final RxInt month = 0.obs;
  final RxInt year = 0.obs;
  late List<DateTime> timeSlots;
  @override
  void onInit() {
    timeSlots = generateTimeSlots();
    super.onInit();
  }

//add the start and end time from abdullah
  List<DateTime> generateTimeSlots() {
    List<DateTime> slots = [];
    DateTime startTime = DateTime.now().copyWith(hour: 10, minute: 0);
    DateTime endTime = DateTime.now().copyWith(hour: 17, minute: 0);

    while (startTime.isBefore(endTime) || startTime.isAtSameMomentAs(endTime)) {
      slots.add(startTime);
      startTime = startTime.add(const Duration(hours: 1));
    }
    return slots;
  }

  @override
  void onClose() {
    hourSelected.value = "";
    selectedDay.value = null;
    super.onClose();
  }
}
