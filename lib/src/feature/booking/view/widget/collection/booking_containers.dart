import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/booking/controller/booking_controller.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

Container calendarContainer(BookingController controller, vendorId) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightAppColors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
        color: AppTheme.lightAppColors.maincolor,
        borderRadius: BorderRadius.circular(30)),
    child: TableCalendar(
      firstDay: DateTime.now(),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: controller.focusedDay.value,
      calendarFormat: controller.calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(controller.selectedDay.value, day);
      },
      headerStyle: HeaderStyle(
        titleTextStyle: const TextStyle(
          fontSize: 15.0, // Font size of the month/year text
          fontWeight: FontWeight.w500, // Font weight of the month/year text
        ),
        formatButtonVisible: false,
        leftChevronIcon: Icon(
          Icons.chevron_left,
          color: AppTheme.lightAppColors.primary, // Color of the left arrow
        ),
        rightChevronIcon: Icon(
          Icons.chevron_right,
          color: AppTheme.lightAppColors.primary,
        ),
      ),
      onDaySelected: (selectedDayValue, focusedDayValue) {
        controller.selectedDay.value = selectedDayValue;
        controller.focusedDay.value = focusedDayValue;

        // Save day, month, and year separately
        controller.day.value = selectedDayValue.day;
        controller.month.value = selectedDayValue.month;
        controller.year.value = selectedDayValue.year;

        // Print the day of the week (e.g., Monday, Tuesday)
        controller.dayOfWeek.value =
            DateFormat('EEEE').format(selectedDayValue);
        controller.getBookingHour(controller.dayOfWeek.value, vendorId);
      },
      onFormatChanged: (format) {
        if (controller.calendarFormat != format) {
          controller.calendarFormat = format;
        }
      },
      onPageChanged: (focusedDay) {
        controller.focusedDay.value = focusedDay;
      },
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: AppTheme.lightAppColors.primary,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: AppTheme.lightAppColors.primary.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
        defaultTextStyle:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        weekendTextStyle:
            TextStyle(color: AppTheme.lightAppColors.subTextcolor),
      ),
    ),
  );
}

hourContainer(BuildContext context, BookingController controller) {
  return Expanded(
    child: AlignedGridView.count(
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      shrinkWrap: true,
      itemCount: controller.workingHors.length,
      itemBuilder: (context, index) {
        return Obx(
          () => GestureDetector(
            onTap: () {
              controller.hourSelected.value = controller
                  .workingHors[index]; // Format the time with seconds set to 00
            },
            child: Container(
              height: 50,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightAppColors.black.withOpacity(0.1),
                    spreadRadius: 1.5,
                    blurRadius: 10,
                    offset: const Offset(0, 1),
                  ),
                ],
                color: controller.hourSelected.value ==
                        controller.workingHors[index]
                    ? AppTheme.lightAppColors.primary
                    : AppTheme.lightAppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  controller.workingHors[index], // Display time as HH:mm:00
                  style: TextStyle(
                      color: controller.hourSelected.value ==
                              controller.workingHors[index]
                          ? AppTheme.lightAppColors.maincolor
                          : AppTheme.lightAppColors.primary,
                      fontSize: 15),
                ),
              ),
            ),
          ),
        );
      },
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
    ),
  );
}
