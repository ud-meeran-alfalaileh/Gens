import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';

class BookingText {
  static mainText(title) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: AppTheme.lightAppColors.subTextcolor,
          fontWeight:
              FontWeight.w500, // Use FontWeight.bold for the bold variant
        ),
      ),
    );
  }
}
