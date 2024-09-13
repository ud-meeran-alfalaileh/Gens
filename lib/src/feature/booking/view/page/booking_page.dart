import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/booking/view/widget/main_widget/booking_widget.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key, required this.vendorId});
  final int vendorId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: BookingWidget(
        vendorId: vendorId,
      ),
    );
  }
}
