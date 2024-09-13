import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';

class AppAuthButton extends StatelessWidget {
  const AppAuthButton({super.key, required this.onTap, required this.title});
  final VoidCallback onTap;
  final String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          width: context.screenWidth,
          height: context.screenHeight * .05,
          decoration: BoxDecoration(
              color: AppTheme.lightAppColors.primary,
              borderRadius: BorderRadius.circular(23)),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 15,
                color: AppTheme.lightAppColors.background,
                fontWeight:
                    FontWeight.w500, // Use FontWeight.bold for the bold variant
              ),
            ),
          ),
        ));
  }
}
