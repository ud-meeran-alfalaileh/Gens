import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';

class VendorRegisterText {
  static mainText(title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Text(
        title,
        style: TextStyle(
            color: AppTheme.lightAppColors.black,
            fontWeight: FontWeight.w400,
            fontSize: 17,
            fontFamily: "Inter"),
      ),
    );
  }

  static secText(title) {
    return Text(
      textAlign: TextAlign.center,
      title,
      style: TextStyle(
          color: AppTheme.lightAppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: 17,
          fontFamily: "Inter"),
    );
  }

  static thirdText(title) {
    return Text(
      textAlign: TextAlign.center,
      title,
      style: TextStyle(
          color: AppTheme.lightAppColors.primary,
          fontWeight: FontWeight.w600,
          fontSize: 22,
          fontFamily: "Inter"),
    );
  }
}
