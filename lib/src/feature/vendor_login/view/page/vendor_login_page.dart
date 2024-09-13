import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/vendor_login/view/widget/main_widget/vendor_login_widget.dart';

class VendorLoginPage extends StatelessWidget {
  const VendorLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: const VendorLoginWidget(),
    );
  }
}
