import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';

class PasswordText {
  static mainText(title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 20,
        color: AppTheme.lightAppColors.primary,
        fontWeight: FontWeight.w600, // Use FontWeight.bold for the bold variant
      ),
    );
  }

  static secText(title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 17,

        color: AppTheme.lightAppColors.mainTextcolor,
        fontWeight: FontWeight.w600, // Use FontWeight.bold for the bold variant
      ),
    );
  }
}
