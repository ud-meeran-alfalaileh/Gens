import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/calendar/controller/calender_controller.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final CalenderControllerr controller = Get.put(CalenderControllerr());
  @override
  void initState() {
    super.initState();

    controller.getCalenderForUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
              left: 10.0, right: 10.0, bottom: context.screenHeight * .1),
          child: Obx(() {
            return SfCalendar(
              view: CalendarView.month,
              onTap: (CalendarTapDetails details) {
                if (details.targetElement == CalendarElement.calendarCell) {
                  details.date!;
                }
              },
              onLongPress: (CalendarLongPressDetails cc) {
                cc.date!;
              },
              dataSource: MeetingDataSource(controller.event.map((event) {
                return Meeting(
                  event.description, "", "",
                  event.date,

                  event.date.add(
                      const Duration(hours: 1)), // End time, assuming 1 hour
                  AppTheme.lightAppColors.primary
                      .withOpacity(0.3), // Background color
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
              todayHighlightColor: AppTheme.lightAppColors.primary,
              cellBorderColor: Colors.grey,
              selectionDecoration: BoxDecoration(
                color: AppTheme.lightAppColors.bordercolor.withOpacity(0.3),
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

class Meeting {
  Meeting(this.eventName, this.userName, this.location, this.from, this.to,
      this.background, this.isAllDay);

  final String eventName;
  final String userName;
  final String location;
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
  String getNotes(int index) => appointments![index].userName;
  @override
  String getLocation(int index) => appointments![index].location;

  @override
  DateTime getEndTime(int index) => appointments![index].to;

  @override
  String getSubject(int index) => appointments![index].eventName;

  @override
  Color getColor(int index) => appointments![index].background;

  @override
  bool isAllDay(int index) => appointments![index].isAllDay;
}
