import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/vendor_calendar/view/widget/main_widget/vendor_calendar_widget.dart';

class VendorCalendar extends StatelessWidget {
  const VendorCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: const VendorCalendarWidget(),
    );
  }
}