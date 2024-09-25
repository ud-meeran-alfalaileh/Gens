import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';

class HistoryText {
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

  static headerText(title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 22,
        color: AppTheme.lightAppColors.primary,
        fontWeight: FontWeight.w600, // Use FontWeight.bold for the bold variant
      ),
    );
  }

  static secText(title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        color: AppTheme.lightAppColors.black,
        fontWeight: FontWeight.w600, // Use FontWeight.bold for the bold variant
      ),
    );
  }

  static thirdText(title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        color: AppTheme.lightAppColors.black,
        fontWeight: FontWeight.w500, // Use FontWeight.bold for the bold variant
      ),
    );
  }
}
