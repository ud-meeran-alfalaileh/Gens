import 'package:flutter/material.dart';

import 'app_extension.dart';

class AppTheme {
  static final light = ThemeData.light().copyWith(
    extensions: [
      lightAppColors,
    ],
  );

  static final lightAppColors = AppColorsExtension(
    primary: const Color(0xff0B3954), //
    background: const Color(0xffffffff), //
    black: const Color(0xff000000), //
    maincolor: const Color.fromARGB(255, 253, 241, 239), //
    bordercolor: const Color(0xffdddddd),
    subTextcolor: const Color(0xff6B7280),
    mainTextcolor: const Color(0xff424242),
    thirdTextcolor: const Color(0xff1363C6),
    containercolor: const Color(0xfff9f9f9),
  );
}
