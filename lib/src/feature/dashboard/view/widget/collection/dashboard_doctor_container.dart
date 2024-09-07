import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/short_text.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/dashboard/view/widget/text/dashboard_text.dart';
import 'package:gens/src/feature/doctor_profile/model/doctor_model.dart';
import 'package:gens/src/feature/doctor_profile/view/page/doctor_page.dart';
import 'package:get/get.dart';

doctorDashboardContainer(BuildContext context, DoctorModel model) {
  return GestureDetector(
    onTap: () {
      Get.to(() => DoctorPage(
            model: model,
          ));
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      width: context.screenWidth,
      height: 170,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightAppColors.black.withOpacity(0.1),
              spreadRadius: 1.5,
              blurRadius: 10,
              offset: const Offset(0, 1),
            ),
          ],
          color: AppTheme.lightAppColors.background),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                  image: AssetImage(model.img),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter),
            ),
          ),
          10.0.kW,
          SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DashboardText.mainText(model.name),
                    (context.screenWidth * .08).kW,
                    const Icon(Icons.favorite_outline)
                  ],
                ),
                7.0.kH,
                Container(
                  width: context.screenWidth * .45,
                  decoration: BoxDecoration(
                      color: AppTheme.lightAppColors.subTextcolor,
                      border: Border.all(
                          color: AppTheme.lightAppColors.bordercolor,
                          width: .5)),
                ),
                7.0.kH,
                DashboardText.typeText(model.type),
                10.0.kH,
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 20,
                      color: AppTheme.lightAppColors.black.withOpacity(0.5),
                    ),
                    // 5.0.kW,
                    DashboardText.locationText(storyShortenText(model.location))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    ),
  );
}
