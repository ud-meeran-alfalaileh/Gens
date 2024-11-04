import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/calendar/view/widget/main_widget/calendar_widget.dart';
import 'package:gens/src/feature/show_user/view/page/show_user_page.dart';
import 'package:gens/src/feature/vendor_calendar/controller/vendor_calendar_controller.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class VendorCalendarWidget extends StatelessWidget {
  const VendorCalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VendorCalendarController());

    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              height: context.screenHeight * .85,
              child: Obx(() => controller.isDay.value == false
                  ? _buildMonthCalendar(controller)
                  : _buildDayCalendar(controller)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    controller.isDay.value = !controller.isDay.value;
                  },
                  icon: Icon(
                    Icons.calendar_month_sharp,
                    color: AppTheme.lightAppColors.secondaryColor,
                    size: 30,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildMonthCalendar(VendorCalendarController controller) {
    return SfCalendar(
      view: CalendarView.month,
      initialDisplayDate: controller.selectedDate.value,
      onTap: (CalendarTapDetails details) {
        if (details.targetElement == CalendarElement.calendarCell &&
            details.date != null) {
          details.date!;
          // controller.isDay.value = !controller.isDay.value;
          // controller.selectedDate.value = details.date!;
        }
      },
      onLongPress: (CalendarLongPressDetails details) {
        if (details.targetElement == CalendarElement.calendarCell &&
            details.date != null) {
          // details.date!;
          controller.isDay.value = !controller.isDay.value;
          controller.selectedDate.value = details.date!;
        }
      },
      dataSource: MeetingDataSource(controller.event.map((event) {
        return Meeting(
          event.status,
          event.status,
          event.userId.toString(),
          event.getDateTime(), // Start time
          event.getDateTime().add(
              const Duration(hours: 1)), // End time, assuming 1 hour duration
          getStatusColor(event.status), // Background color
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
        border: Border.all(color: AppTheme.lightAppColors.black, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  _buildDayCalendar(VendorCalendarController controller) {
    return SizedBox(
      child: SfCalendar(
        view: CalendarView.day,
        initialDisplayDate: controller.selectedDate.value,
        onTap: (CalendarTapDetails details) {
          if (details.targetElement == CalendarElement.appointment &&
              details.appointments != null &&
              details.appointments!.isNotEmpty) {
            // Get the tapped appointment
            final Meeting tappedEvent = details.appointments!.first;

            // Navigate to the `ShowUserPage` with the ID from the event
            Get.to(() => ShowUserPage(id: int.parse(tappedEvent.location)));
          }
        },
        dataSource: MeetingDataSource(controller.event.map((event) {
          return Meeting(
            event.userName, event.userName, event.userId.toString(),
            event.getDateTime(), // Start time
            event.getDateTime().add(
                const Duration(hours: 1)), // End time, assuming 1 hour duration
            getStatusColor(event.status), // Background color
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
          border: Border.all(color: AppTheme.lightAppColors.black, width: 2),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

Color getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'rejected':
      return AppTheme.lightAppColors.secondaryColor; // Red for rejected status
    case 'done':
      return AppTheme.lightAppColors.primary; // Green for completed status
    case 'upcoming':
      return AppTheme.lightAppColors.maincolor; // Blue for upcoming status
    case 'pending':
      return Colors.orangeAccent; // Orange for pending status
    default:
      return Colors.grey; // Default color for unknown statuses
  }
}
