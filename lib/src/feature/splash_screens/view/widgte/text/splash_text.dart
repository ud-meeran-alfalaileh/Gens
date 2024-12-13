import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';

class SplashText {
  static mainText(title) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          color: AppTheme.lightAppColors.primary,
          fontWeight:
              FontWeight.w900, // Use FontWeight.bold for the bold variant
        ),
      ),
    );
  }

  static secText(title) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 15,
          color: AppTheme.lightAppColors.black,
          fontWeight:
              FontWeight.w400, // Use FontWeight.bold for the bold variant
        ),
      ),
    );
  }

  static thirdText(title) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: AppTheme.lightAppColors.background,
          fontWeight:
              FontWeight.w700, // Use FontWeight.bold for the bold variant
        ),
      ),
    );
  }
}
