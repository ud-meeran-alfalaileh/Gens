import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/profile/controller/profile_controller.dart';
import 'package:get/get.dart';

void showPopupButtons(BuildContext context, ProfileController controller) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: context.screenHeight * .18,
        width: context.screenWidth,
        decoration: BoxDecoration(
            color: AppTheme.lightAppColors.background,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          children: [
            SizedBox(
              height: context.screenHeight * .01,
            ),
            profileImageButton(context, () {
              controller.pickImages(context);
            }, "library".tr, Icons.image_outlined),
            const Divider(),
            10.0.kH,
            profileImageButton(context, () {
              controller.takeImages(context);
            }, "camera".tr, Icons.camera_alt_outlined),
            // profileImageButton(context, () {
            //   // controller.takeImages(token);
            // },
            // "Remove current picture", Icons.delete_outline_outlined),
          ],
        ),
      );
    },
  );
}

GestureDetector profileImageButton(
    BuildContext context, VoidCallback onTap, title, IconData icon) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: title == "Remove current picture"
              ? Colors.red
              : AppTheme.lightAppColors.black,
          size: 25,
        ),
        (15.0).kW,
        Container(
          width: context.screenWidth * .7,
          height: context.screenHeight * 0.05,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: 'Baloo',
              fontSize: 16,
              color: title == "Remove current picture"
                  ? Colors.red
                  : AppTheme.lightAppColors.black,
              fontWeight:
                  FontWeight.w500, // Use  FontWeight.bold for the bold variant
            ),
          ),
        ),
      ],
    ),
  );
}
