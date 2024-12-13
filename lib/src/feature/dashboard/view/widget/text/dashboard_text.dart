import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';

class DashboardText {
  static mainText(title) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 17,
          color: AppTheme.lightAppColors.black,
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
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 17,
          color: AppTheme.lightAppColors.primary,
          fontWeight:
              FontWeight.w700, // Use FontWeight.bold for the bold variant
        ),
      ),
    );
  }

  static thirdText(title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        color: AppTheme.lightAppColors.black.withOpacity(.5),
        fontWeight: FontWeight.w500, // Use FontWeight.bold for the bold variant
      ),
    );
  }

  static typeText(title) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 16,
          color: AppTheme.lightAppColors.black.withOpacity(0.7),
          fontWeight:
              FontWeight.w600, // Use FontWeight.bold for the bold variant
        ),
      ),
    );
  }

  static locationText(title) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          color: AppTheme.lightAppColors.black.withOpacity(0.5),
          fontWeight:
              FontWeight.w400, // Use FontWeight.bold for the bold variant
        ),
      ),
    );
  }

  static ratingText(title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,
        color: AppTheme.lightAppColors.black.withOpacity(0.6),
        fontWeight: FontWeight.w400, // Use FontWeight.bold for the bold variant
      ),
    );
  }

  static containerText(title, isSelected) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,

        color: isSelected
            ? AppTheme.lightAppColors.background
            : AppTheme.lightAppColors.primary,
        fontWeight: FontWeight.w600, // Use FontWeight.bold for the bold variant
      ),
    );
  }

  static reviewText(
    title,
  ) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 16,

        color: AppTheme.lightAppColors.mainTextcolor,
        fontWeight: FontWeight.w600, // Use FontWeight.bold for the bold variant
      ),
    );
  }

  static reviewSecText(
    title,
  ) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,

        color: AppTheme.lightAppColors.mainTextcolor,
        fontWeight: FontWeight.w400, // Use FontWeight.bold for the bold variant
      ),
    );
  }

  static reviewThText(
    title,
  ) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,

        color: AppTheme.lightAppColors.mainTextcolor,
        fontWeight: FontWeight.w500, // Use FontWeight.bold for the bold variant
      ),
    );
  }
}
