import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';

class ServicesText {
  static mainText(title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 13,
        color: AppTheme.lightAppColors.mainTextcolor,
        fontWeight: FontWeight.w500, // Use FontWeight.bold for the bold variant
      ),
    );
  }
  static addSrviceText(title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 13,
        color: AppTheme.lightAppColors.secondaryColor,
        fontWeight: FontWeight.w500, // Use FontWeight.bold for the bold variant
      ),
    );
  }

  static secText(title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 17,
        color: AppTheme.lightAppColors.mainTextcolor,
        fontWeight: FontWeight.w600, // Use FontWeight.bold for the bold variant
      ),
    );
  }

  static thirdText(title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        color: AppTheme.lightAppColors.mainTextcolor.withOpacity(0.8),
        fontWeight: FontWeight.w500, // Use FontWeight.bold for the bold variant
      ),
    );
  }

  static ffText(title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 18,
        color: AppTheme.lightAppColors.mainTextcolor,
        fontWeight: FontWeight.w700, // Use FontWeight.bold for the bold variant
      ),
    );
  }

  static addMainText(title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 30,
        color: AppTheme.lightAppColors.mainTextcolor,
        fontWeight: FontWeight.w400, // Use FontWeight.bold for the bold variant
      ),
    );
  }
}
