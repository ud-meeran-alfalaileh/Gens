import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/dashboard/view/widget/text/dashboard_text.dart';

doctorDashboardContainer(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(20),
    width: context.screenWidth * .9,
    height: context.screenHeight * .2,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightAppColors.black.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 20,
            offset: const Offset(0, 1),
          ),
        ],
        color: AppTheme.lightAppColors.background),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: const DecorationImage(
                image: AssetImage('assets/image/doctor.avif'),
                fit: BoxFit.cover,
                alignment: Alignment.topCenter),
          ),
        ),
        10.0.kW,
        SizedBox(
          width: context.screenWidth * .434,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DashboardText.mainText("Israa Elshebli"),
                  40.0.kW,
                  const Icon(Icons.favorite_outline)
                ],
              ),
              const Divider(),
              DashboardText.typeText("Cardiologist"),
              10.0.kH,
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 20,
                    color: AppTheme.lightAppColors.black.withOpacity(0.5),
                  ),
                  // 5.0.kW,
                  DashboardText.locationText("Arab Bank, Pr. 8, Amman")
                ],
              )
            ],
          ),
        )
      ],
    ),
  );
}
