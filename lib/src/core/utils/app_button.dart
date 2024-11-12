import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';

// ignore: must_be_immutable
class AppButton extends StatelessWidget {
  AppButton({super.key, required this.onTap, required this.title, this.color});
  final VoidCallback onTap;
  Color? color;
  final String title;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          width: context.screenWidth,
          decoration: BoxDecoration(
              color: color ?? AppTheme.lightAppColors.primary,
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
