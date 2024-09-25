import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';

class ForgetPasswordText {
  static mainText(title) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 25,
        color: AppTheme.lightAppColors.primary,
        fontWeight: FontWeight.w900, // Use FontWeight.bold for the bold variant
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
          fontSize: 19,
          color: AppTheme.lightAppColors.subTextcolor,
          fontWeight:
              FontWeight.w500, // Use FontWeight.bold for the bold variant
        ),
      ),
    );
  }
}
