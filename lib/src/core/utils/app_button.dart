import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.onTap, required this.title});
  final VoidCallback onTap;
  final String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          width: context.screenWidth,
          height: context.screenHeight * .05,
          decoration: BoxDecoration(
              color: AppTheme.lightAppColors.primary,
              borderRadius: BorderRadius.circular(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  color: AppTheme.lightAppColors.background,
                  fontWeight: FontWeight
                      .w500, // Use FontWeight.bold for the bold variant
                ),
              ),
            ],
          ),
        ));
  }
}
