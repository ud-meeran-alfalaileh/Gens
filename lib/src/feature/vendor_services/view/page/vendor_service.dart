import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/vendor_services/view/widget/main_widget/vendor_service_widget.dart';

class VendorServicePage extends StatelessWidget {
  const VendorServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: const VendorServiceWidget(),
    );
  }
}
