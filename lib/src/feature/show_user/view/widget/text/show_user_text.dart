import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';

class ShowUserText {
  static mainText(title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 18,
        color: AppTheme.lightAppColors.black.withOpacity(.8),
        fontWeight: FontWeight.w600, // Use FontWeight.bold for the bold variant
      ),
    );
  }
}
