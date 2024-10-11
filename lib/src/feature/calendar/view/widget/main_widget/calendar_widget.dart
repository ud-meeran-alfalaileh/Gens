import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/calendar/controller/calender_controller.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final CalenderControllerr controller = Get.put(CalenderControllerr());

    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(() {
            // Ensure events are loaded before building the calendar
            if (controller.event.isEmpty) {
              return const Center(
                  child: CircularProgressIndicator()); // Show loading indicator
            }

            return SfCalendar(
              view: CalendarView.month,
              onTap: (CalendarTapDetails details) {
                if (details.targetElement == CalendarElement.calendarCell) {
                  DateTime selectedDate = details.date!;
                  // Get.to(() => DayCalendarView(selectedDate: selectedDate));
                }
              },
              onLongPress: (CalendarLongPressDetails cc) {
                DateTime selectedDate = cc.date!;

                // Get.to(() => DayCalendarView(selectedDate: selectedDate));
              },

              dataSource: MeetingDataSource(controller.event.map((event) {
                print("Mapping event: ${event.description} on ${event.date}");
                return Meeting(
                  event.description, // Use event description directly
                  event.date, // Start time
                  event.date.add(
                      const Duration(hours: 1)), // End time, assuming 1 hour
                  const Color(0xFF0F8644), // Background color
                  false, // Not an all-day event
                );
              }).toList()),

              monthViewSettings: const MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
                showAgenda: true,
              ),

              headerStyle: CalendarHeaderStyle(
                backgroundColor: AppTheme.lightAppColors.background,
                textAlign: TextAlign.center,
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.lightAppColors.black,
                ),
              ),
              viewHeaderStyle: ViewHeaderStyle(
                backgroundColor: Colors.grey[200],
                dayTextStyle: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              todayHighlightColor:
                  AppTheme.lightAppColors.primary, // Highlight today in red
              cellBorderColor: Colors.grey, // Cell border color
              selectionDecoration: BoxDecoration(
                color: AppTheme.lightAppColors.bordercolor
                    .withOpacity(0.3), // Selected cell background color
                border:
                    Border.all(color: AppTheme.lightAppColors.black, width: 2),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// class DayCalendarView extends StatelessWidget {
//   final DateTime selectedDate;
//   const DayCalendarView({super.key, required this.selectedDate});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Events on ${selectedDate.toLocal()}'),
//       ),
//       body: Obx(() {
//         final controller = Get.find<CalenderControllerr>();
//         // Filter events for the selected date
//         final dailyEvents = controller.event.where((event) {
//           return event.date.year == selectedDate.year &&
//               event.date.month == selectedDate.month &&
//               event.date.day == selectedDate.day;
//         }).map((event) {
//           return Meeting(
//             event.serviceName,
//             event.date,
//             event.date
//                 .add(const Duration(hours: 1)), // Assuming 1 hour duration
//             const Color(0xFF0F8644),
//             false,
//           );
//         }).toList();
//         return SfCalendar(
//           view: CalendarView.day,
//           initialDisplayDate: selectedDate,
//           dataSource: MeetingDataSource(dailyEvents),
//         );
//       }),
//     );
//   }
// }

// Meeting class definition
class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  final String eventName;
  final DateTime from;
  final DateTime to;
  final Color background;
  final bool isAllDay;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) => appointments![index].from;

  @override
  DateTime getEndTime(int index) => appointments![index].to;

  @override
  String getSubject(int index) => appointments![index].eventName;

  @override
  Color getColor(int index) => appointments![index].background;

  @override
  bool isAllDay(int index) => appointments![index].isAllDay;
}
