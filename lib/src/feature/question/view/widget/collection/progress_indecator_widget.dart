import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';

class ProgressBar extends StatelessWidget {
  final double progress;
  final int currentPage;
  final int totalPages;

  const ProgressBar({
    super.key,
    required this.progress,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth * .7,
      child: LinearProgressIndicator(
        value: progress,
        borderRadius: BorderRadius.circular(10),
        color: AppTheme.lightAppColors.primary,
        backgroundColor: AppTheme.lightAppColors.primary.withOpacity(0.2),
        minHeight: 20,
      ),
    );
  }
}
