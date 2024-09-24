import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';

class PageText {
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
}
