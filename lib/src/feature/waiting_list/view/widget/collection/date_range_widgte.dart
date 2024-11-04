import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/core/utils/snack_bar.dart';
import 'package:gens/src/feature/doctor_profile/view/widget/text/doctor_text.dart';
import 'package:gens/src/feature/waiting_list/controller/waiting_list_controller.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class DateRangeWidget extends GetView<WaitingListController> {
  const DateRangeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        controller.setDateValue();
                        Get.back();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: AppTheme.lightAppColors.black.withOpacity(.8),
                      )),
                  const Spacer(),
                  DoctorText.mainText("Range Date".tr),
                  const Spacer(),
                  (30.0).kW,
                ],
              ),
              70.0.kH,
              Obx(() => _buildCalendarContainer(controller, context)),
              50.0.kH,
              SizedBox(
                width: context.screenWidth * .6,
                child: AppButton(
                    onTap: () {
                      controller.setDateValue();
                      if (controller.formattedStart.value == '') {
                        showSnackBar("Select Start Date", "Error",
                            AppTheme.lightAppColors.bordercolor);
                      } else {
                        Get.back();
                      }
                    },
                    title: ("Confirm".tr)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildCalendarContainer(
      WaitingListController controller, BuildContext context) {
    DateTime now = DateTime.now();
    DateTime twoMonthsLater = DateTime(now.year, now.month + 2, now.day);

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
          borderRadius: BorderRadius.circular(30),
        ),
        child: TableCalendar(
          firstDay: now, // Start date: now
          lastDay: twoMonthsLater, // End date: two months later
          focusedDay: controller.focusedDay.value,
          selectedDayPredicate: (day) {
            // This will check if the day is the same as the selected day
            return isSameDay(controller.selectedDay.value, day);
          },
          rangeSelectionMode: controller.rangeSelectionMode.value,
          rangeStartDay: controller.rangeStartDay.value,
          rangeEndDay: controller.rangeEndDay.value,
          calendarFormat: controller.calendarFormat,
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
          onRangeSelected: (start, end, focusedDayValue) {
            // Update the selected and focused day in the controller
            controller.rangeStartDay.value = start;
            controller.rangeEndDay.value = end;
            controller.focusedDay.value = focusedDayValue;

            // Notify if the range includes Friday or Sunday

            // Assuming there's a method to get booking hours for the selected range
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
            rangeStartDecoration: BoxDecoration(
              color: AppTheme.lightAppColors.primary,
              shape: BoxShape.circle,
            ),
            rangeEndDecoration: BoxDecoration(
              color: AppTheme.lightAppColors.primary,
              shape: BoxShape.circle,
            ),
            withinRangeDecoration: BoxDecoration(
              color: AppTheme.lightAppColors.primary.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: AppTheme.lightAppColors.primary.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            defaultTextStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w600),
            weekendTextStyle:
                TextStyle(color: AppTheme.lightAppColors.subTextcolor),
          ),
        ));
  }

  // void _showDayWarningDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: AppTheme.lightAppColors.background,
  //         title: const Text("Notice"),
  //         content: Text(
  //           "The doctor does not work on some selected day".tr,
  //           style: TextStyle(
  //               color: AppTheme.lightAppColors.black, fontFamily: "Inter"),
  //         ),
  //         actions: [
  //           TextButton(
  //             child: const Text("Done"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  // bool _rangeIncludesRestrictedDays(DateTime? start, DateTime? end) {
  //   if (start == null || end == null) return false;

  //   for (var day = start;
  //       day.isBefore(end.add(const Duration(days: 1)));
  //       day = day.add(const Duration(days: 1))) {
  //     if (day.weekday == DateTime.friday || day.weekday == DateTime.sunday) {
  //       return true;
  //     }
  //   }

  //   return false;
  // }
}
