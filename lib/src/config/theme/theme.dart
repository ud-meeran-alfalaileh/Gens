import 'package:flutter/material.dart';

import 'app_extension.dart';

class AppTheme {
  static final light = ThemeData.light().copyWith(
    extensions: [
      lightAppColors,
    ],
  );

  static final lightAppColors = AppColorsExtension(
    primary: const Color(0xff0E3B52), //
    background: const Color(0xffffffff), //
    black: const Color(0xff000000), //
    maincolor: const Color(0xffF6F5E9), //
    bordercolor: const Color(0xffdddddd),
    subTextcolor: const Color(0xff6B7280),
    mainTextcolor: const Color(0xff424242),
    thirdTextcolor: const Color(0xff1363C6),
    containercolor: const Color(0xffECDEC7),
    secondaryColor: const Color(0xffFF6260),
  );
}
