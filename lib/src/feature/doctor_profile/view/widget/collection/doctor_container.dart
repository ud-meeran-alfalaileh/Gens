import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/short_text.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/dashboard/view/widget/text/dashboard_text.dart';
import 'package:gens/src/feature/doctor_profile/model/doctor_model.dart';

doctorContainer(BuildContext context, DoctorModelById model) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    width: context.screenWidth * .8,
    height: context.screenHeight * .17,
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
    child: SizedBox(
      // width: context.screenWidth * .434,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.0.kH,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DashboardText.mainText(vendorNShortText(model.name)),
            ],
          ),
          7.0.kH,
          Container(
            width: context.screenWidth,
            decoration: BoxDecoration(
                color: AppTheme.lightAppColors.subTextcolor,
                border: Border.all(
                    color: AppTheme.lightAppColors.bordercolor, width: .5)),
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
              DashboardText.locationText(model.location)
            ],
          )
        ],
      ),
    ),
  );
}
