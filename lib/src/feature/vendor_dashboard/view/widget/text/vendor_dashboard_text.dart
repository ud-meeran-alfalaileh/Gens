import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';

class VendorDashboardText {
  static mainText(title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 24,
        color: AppTheme.lightAppColors.black,
        fontWeight: FontWeight.w400, // Use FontWeight.bold for the bold variant
      ),
    );
  }

  static registerText(title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 27,
        color: AppTheme.lightAppColors.black,
        fontWeight: FontWeight.w700, // Use FontWeight.bold for the bold variant
      ),
    );
  }

  static emptyText(title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        color: AppTheme.lightAppColors.black,
        fontWeight: FontWeight.w400, // Use FontWeight.bold for the bold variant
      ),
    );
  }

  static secText(title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 18,
        color: AppTheme.lightAppColors.black,
        fontWeight: FontWeight.w700, // Use FontWeight.bold for the bold variant
      ),
    );
  }

  static thirdText(title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        color: AppTheme.lightAppColors.black,
        fontWeight: FontWeight.w500, // Use FontWeight.bold for the bold variant
      ),
    );
  }

  static timeText(title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        color: AppTheme.lightAppColors.black.withOpacity(0.7),
        fontWeight: FontWeight.w500, // Use FontWeight.bold for the bold variant
      ),
    );
  }
}
