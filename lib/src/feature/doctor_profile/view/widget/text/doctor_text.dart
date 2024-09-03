import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';

class DoctorText {
  static mainText(title) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 20,
          color: AppTheme.lightAppColors.black.withOpacity(.8),
          fontWeight:
              FontWeight.w600, // Use FontWeight.bold for the bold variant
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
          fontSize: 14,
          color: AppTheme.lightAppColors.black.withOpacity(.8),
          fontWeight:
              FontWeight.w700, // Use FontWeight.bold for the bold variant
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
          fontSize: 12,
          color: AppTheme.lightAppColors.black.withOpacity(.4),
          fontWeight:
              FontWeight.w400, // Use FontWeight.bold for the bold variant
        ),
      ),
    );
  }
}
