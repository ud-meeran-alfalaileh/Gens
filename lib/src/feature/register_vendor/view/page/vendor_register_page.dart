import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/register_vendor/view/widget/main_widget/vendor_register_widget.dart';

class VendorRegisterPage extends StatelessWidget {
  const VendorRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: const SafeArea(child: VendorRegisterWidget()),
    );
  }
}
