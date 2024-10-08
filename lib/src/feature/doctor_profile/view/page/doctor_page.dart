import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/doctor_profile/view/widget/main_widget/doctor_widget.dart';

class DoctorPage extends StatelessWidget {
  const DoctorPage({super.key, required this.model, required this.type});
  final String type;
  final int model;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: DoctorWidget(
        model: model,
        type: type,
      ),
    );
  }
}
