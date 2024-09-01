import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/dashboard/model/dashboard_filter_model.dart';
import 'package:gens/src/feature/dashboard/view/widget/text/dashboard_text.dart';

class DashboardContainer extends StatelessWidget {
  final DashboardFilterModel model;

  const DashboardContainer({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: model.onTap,
      child: Container(
        height: context.screenHeight * .04,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: model.isSelected
              ? AppTheme.lightAppColors.primary
              : AppTheme.lightAppColors.background,
          border: Border.all(
            color: model.isSelected
                ? AppTheme.lightAppColors.primary
                : AppTheme.lightAppColors.primary,
            width: 1,
          ),
        ),
        child: Center(
          child: DashboardText.containerText(model.title, model.isSelected),
        ),
      ),
    );
  }
}
