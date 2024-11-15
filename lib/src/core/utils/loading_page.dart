import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/test.dart';

Align loadingPage(BuildContext context) {
  return Align(
      alignment: Alignment.center,
      child: Container(
        width: context.screenWidth,
        height: context.screenHeight,
        color: AppTheme.lightAppColors.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
                child: RotatingImage(
              image: "assets/image/logo.png",
            )),
            CircularProgressIndicator(
              color: AppTheme.lightAppColors.primary,
            )
          ],
        ),
      ));
}
