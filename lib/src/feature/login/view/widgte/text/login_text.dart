import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:get/get.dart';

class LoginText {
  static haveAccount(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text.rich(TextSpan(
          text: "dontHaveAccoint".tr,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Inter',
            color: AppTheme.lightAppColors.mainTextcolor,
          ),
          children: [
            TextSpan(
              text: "Register".tr,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.lightAppColors.primary,
                fontFamily: 'Inter',
              ),
            )
          ])),
    );
  }

  static dontHaveAccount(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Text.rich(TextSpan(
          text: "HaveAccount".tr,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Inter',
            color: AppTheme.lightAppColors.mainTextcolor,
          ),
          children: [
            TextSpan(
              text: "Login".tr,
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.lightAppColors.primary,
                fontFamily: 'Inter',
              ),
            )
          ])),
    );
  }

  static mainText(title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        color: AppTheme.lightAppColors.primary,
        fontWeight: FontWeight.w900, // Use FontWeight.bold for the bold variant
      ),
    );
  }

  static secText(title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        color: AppTheme.lightAppColors.subTextcolor,
        fontWeight: FontWeight.w500, // Use FontWeight.bold for the bold variant
      ),
    );
  }
}
