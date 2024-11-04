import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';

class VendorLoadingPage extends StatelessWidget {
  const VendorLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
