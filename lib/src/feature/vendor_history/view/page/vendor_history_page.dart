import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/vendor_history/view/widget/main_widget/vendor_history_widget.dart';

class VendorHistoryPage extends StatelessWidget {
  const VendorHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: const SafeArea(
        bottom: false,
        child: VendorHistoryWidget(),
      ),
    );
  }
}
