import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';

class WaitingListText {
  static mainText(title) {
    return Text(
      title,
      style: TextStyle(
          color: AppTheme.lightAppColors.black,
          fontFamily: "Inter",
          fontSize: 20,
          fontWeight: FontWeight.w600),
    );
  }

  static secText(title) {
    return Text(
      title,
      style: TextStyle(
          color: AppTheme.lightAppColors.black,
          fontFamily: "Inter",
          fontSize: 17,
          fontWeight: FontWeight.w500),
    );
  }

  static thirdText(title,) {
    return Text(
      title,
      style: TextStyle(
          color: AppTheme.lightAppColors.black,
          fontFamily: "Inter",
          fontSize: 15,
          fontWeight: FontWeight.w400),
    );
  }
  static selectDateText(title,) {
    return Text(
      title,
      style: TextStyle(
          color: AppTheme.lightAppColors.secondaryColor,
          fontFamily: "Inter",
          fontSize: 15,
          fontWeight: FontWeight.w400),
    );
  }
}
