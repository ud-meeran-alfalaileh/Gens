import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/waiting_list/view/widget/main_widget/vendor_waiting_list_widget.dart';

class VendorWaitingList extends StatelessWidget {
  const VendorWaitingList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: const VendorWaitingListWidget(),
    );
  }
}