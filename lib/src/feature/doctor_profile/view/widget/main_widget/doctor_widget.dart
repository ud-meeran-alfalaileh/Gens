import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/doctor_profile/controller/doctor_controller.dart';
import 'package:gens/src/feature/doctor_profile/model/doctor_model.dart';
import 'package:gens/src/feature/doctor_profile/view/widget/collection/doctor_container.dart';
import 'package:gens/src/feature/doctor_profile/view/widget/text/doctor_text.dart';
import 'package:get/get.dart';

class DoctorWidget extends StatelessWidget {
  const DoctorWidget({super.key, required this.model});
  final DoctorModel model;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DoctorController());
    int maxLength = 90;

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppTheme.lightAppColors.black.withOpacity(.8),
                    )),
                DoctorText.mainText("Details"),
                const Icon(Icons.favorite_border_outlined),
              ],
            ),
            (context.screenHeight * .02).kH,
            doctorContainer(context, model),
            (context.screenHeight * .02).kH,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                doctorRowCircle(context, "assets/image/profile-2.svg",
                    model.patient.toString(), "patients"),
                doctorRowCircle(context, "assets/image/review.svg",
                    model.rating.toString(), "rating"),
                doctorRowCircle(context, "assets/image/messages.svg",
                    model.review.toString(), "reviews"),
              ],
            ),
            (context.screenHeight * .03).kH,
            DoctorText.mainText("About Me"),
            (context.screenHeight * .01).kH,
            Obx(
              () => GestureDetector(
                onTap: () {
                  controller.toggleExpanded();
                },
                child: Text.rich(
                  TextSpan(
                    text: controller.isExpanded.value ||
                            model.about.length <= maxLength
                        ? model.about
                        : model.about.substring(0, maxLength),
                    style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'Alexandria',
                      color: AppTheme.lightAppColors.subTextcolor,
                    ),
                    children: [
                      TextSpan(
                        text: controller.isExpanded.value
                            ? " see less".tr
                            : " see more".tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.lightAppColors.primary,
                          fontFamily: 'Alexandria',
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            (context.screenHeight * .03).kH,
            DoctorText.mainText("Working Time"),
            (context.screenHeight * .01).kH,
            Text(
              model.workingTime,
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Alexandria',
                color: AppTheme.lightAppColors.subTextcolor,
              ),
            ),
            AppButton(onTap: () {}, title: "Book Appointment".tr)
          ],
        ),
      ),
    );
  }

  Column doctorRowCircle(BuildContext context, image, number, title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          width: 65,
          height: 60,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: AppTheme.lightAppColors.maincolor),
          child: SvgPicture.asset(image),
        ),
        (context.screenHeight * .01).kH,
        DoctorText.secText("$number+"),
        DoctorText.thirdText(title),
      ],
    );
  }
}
