import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gens/src/config/sizes/short_text.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/dashboard/view/widget/text/dashboard_text.dart';
import 'package:gens/src/feature/doctor_profile/controller/doctor_controller.dart';
import 'package:gens/src/feature/doctor_profile/model/doctor_model.dart';
import 'package:gens/src/feature/doctor_profile/view/page/doctor_page.dart';
import 'package:get/get.dart';

doctorDashboardContainer(
    BuildContext context, Vendor model, DoctorController controller) {
  return GestureDetector(
    onTap: () {
      Get.to(() => DoctorPage(
            model: model.vendorId,
            type: 'dashboard',
          ));
    },
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      width: context.screenWidth,
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
            width: context.screenWidth * .32,
            height: 130,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: model.images.isNotEmpty
                    ? CachedNetworkImageProvider(
                        model.images[0].imgUrl1,
                      )
                    : const AssetImage("assets/image/logo_image.png")
                        as ImageProvider,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          10.0.kW,
          SizedBox(
            width: context.screenWidth * .47,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DashboardText.mainText(vendorShortText(model.name)),
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
                    DashboardText.locationText(locationShortText(model.address))
                  ],
                ),
                10.0.kH,
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/image/ratingStar.svg",
                      color: AppTheme.lightAppColors.secondaryColor,
                      height: 15,
                    ),
                    10.0.kW,
                    DashboardText.ratingText(model.avgRating.toString()),
                    15.0.kW,
                    Container(
                      width: 2,
                      height: 30,
                      color: AppTheme.lightAppColors.bordercolor,
                    ),
                    15.0.kW,
                    DashboardText.ratingText(
                        "${model.reviewCount.toString()} "),
                    DashboardText.ratingText('Reviews'.tr),
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
