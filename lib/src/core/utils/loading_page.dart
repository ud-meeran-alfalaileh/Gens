import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';

Align loadingPage(BuildContext context) {
  return Align(
      alignment: Alignment.center,
      child: Container(
        width: context.screenWidth,
        height: context.screenHeight,
        color: AppTheme.lightAppColors.background,
        child: Center(
          child: SpinKitCubeGrid(
            itemBuilder: (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: index.isEven
                      ? AppTheme.lightAppColors.primary
                      : AppTheme.lightAppColors.maincolor,
                ),
              );
            },
          ),
        ),
      ));
}
