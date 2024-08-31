import 'package:flutter/material.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  AppColorsExtension(
      {required this.primary,
      required this.background,
      required this.black,
      required this.maincolor,
      required this.bordercolor,
      required this.mainTextcolor,
      required this.thirdTextcolor,
      required this.containercolor,
      required this.subTextcolor});

  final Color primary;
  final Color background;
  final Color black;
  final Color maincolor;
  final Color bordercolor;
  final Color containercolor;
  final Color subTextcolor;
  final Color mainTextcolor;
  final Color thirdTextcolor;

  @override
  ThemeExtension<AppColorsExtension> copyWith(
      {Color? primary,
      Color? background,
      Color? buttoncolor,
      Color? containercolor,
      Color? bordercolor,
      Color? black,
      Color? thirdTextcolor,
      Color? subTextcolor,
      Color? mainTextcolor}) {
    return AppColorsExtension(
        primary: primary ?? this.primary,
        black: black ?? this.black,
        background: background ?? this.background,
        containercolor: containercolor ?? this.containercolor,
        maincolor: maincolor,
        bordercolor: bordercolor ?? this.bordercolor,
        thirdTextcolor: thirdTextcolor ?? this.thirdTextcolor,
        subTextcolor: subTextcolor ?? this.subTextcolor,
        mainTextcolor: mainTextcolor ?? this.mainTextcolor);
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
    covariant ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) {
      return this;
    }

    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      black: Color.lerp(black, other.black, t)!,
      background: Color.lerp(background, other.background, t)!,
      thirdTextcolor: Color.lerp(thirdTextcolor, other.thirdTextcolor, t)!,
      containercolor: Color.lerp(containercolor, other.containercolor, t)!,
      maincolor: Color.lerp(maincolor, other.maincolor, t)!,
      bordercolor: Color.lerp(bordercolor, other.bordercolor, t)!,
      mainTextcolor: Color.lerp(mainTextcolor, other.mainTextcolor, t)!,
      subTextcolor: Color.lerp(subTextcolor, other.subTextcolor, t)!,
    );
  }
}
