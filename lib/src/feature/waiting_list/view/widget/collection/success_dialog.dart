import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/booking/view/widget/text/login_text.dart';
import 'package:gens/src/feature/doctor_profile/view/widget/text/doctor_text.dart';
import 'package:gens/src/feature/nav_bar/view/main/navbar_page.dart';
import 'package:get/get.dart';

waitingSuccess(context, ) {
  return showDialog(
    barrierDismissible:
        false, // Prevents closing the dialog when tapping outside

    context: context,
    builder: (BuildContext context) {
      return Dialog(
        clipBehavior: Clip.hardEdge,
        backgroundColor: AppTheme.lightAppColors.background,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize:
                MainAxisSize.min, // This allows the column to fit the content
            children: [
              SvgPicture.asset("assets/image/Image.svg"),
              (context.screenHeight * .06).kH,
              DoctorText.mainText("Congratulations!"),
              BookingText.mainText(
                  "Your appointment is Add to the Waiting list "),
              (context.screenHeight * .03).kH,
              AppButton(
                  onTap: () {
                    Get.offAll(() => const NavBarPage());
                  },
                  title: "Done"),
              (context.screenHeight * .05).kH,
            ],
          ),
        ),
      );
    },
  );
}
