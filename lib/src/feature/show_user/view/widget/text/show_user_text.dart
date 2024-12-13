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
  static secText(title) {
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
  static dateText(title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        color: AppTheme.lightAppColors.black.withOpacity(.8),
        fontWeight: FontWeight.w500, // Use FontWeight.bold for the bold variant
      ),
    );
  }
  static noteText(title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        color: AppTheme.lightAppColors.black.withOpacity(.8),
        fontWeight: FontWeight.w400, // Use FontWeight.bold for the bold variant
      ),
    );
  }
}
