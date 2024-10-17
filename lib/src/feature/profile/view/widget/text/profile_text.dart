import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:get/get.dart';

class ProfileText {
  static mainText(title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        color: AppTheme.lightAppColors.black,
        fontWeight: FontWeight.w800, // Use FontWeight.bold for the bold variant
      ),
    );
  }

  static secText(title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        color: AppTheme.lightAppColors.black.withOpacity(0.5),
        fontWeight: FontWeight.w500, // Use FontWeight.bold for the bold variant
      ),
    );
  }

  static secText1(title) {
    return Text(
      title,
      textDirection: TextDirection.ltr,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        color: AppTheme.lightAppColors.black.withOpacity(0.5),
        fontWeight: FontWeight.w500, // Use FontWeight.bold for the bold variant
      ),
    );
  }

  static containerText(title, isSelected) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        color: title == "logout".tr
            ? Colors.red
            : isSelected
                ? AppTheme.lightAppColors.primary
                : AppTheme.lightAppColors.subTextcolor.withOpacity(.5),
        fontWeight: FontWeight.w500, // Use FontWeight.bold for the bold variant
      ),
    );
  }

  static thirdText(title) {
    return Text(
      title,
      style: TextStyle(
          color: AppTheme.lightAppColors.black,
          fontWeight: FontWeight.w400,
          fontSize: 17,
          fontFamily: "Inter"),
    );
  }
}
