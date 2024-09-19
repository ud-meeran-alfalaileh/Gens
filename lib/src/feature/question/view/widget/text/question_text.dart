import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';

class QuestionText {
  static mainText(title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        color: AppTheme.lightAppColors.black,
        fontWeight: FontWeight.w700, // Use FontWeight.bold for the bold variant
      ),
    );
  }

  static secText(title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 25,
        color: AppTheme.lightAppColors.primary,
        fontWeight: FontWeight.w700, // Use FontWeight.bold for the bold variant
      ),
    );
  }
}
