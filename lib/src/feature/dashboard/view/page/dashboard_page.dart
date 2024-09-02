import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/dashboard/view/widget/main_widget/dashborad_widget.dart';
import 'package:get/get.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      drawer: Drawer(
        elevation: 0,
        backgroundColor: Colors.white,
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              60.0.kH,
              Image.asset(
                "assets/icon/Logo.png",
                width: 100,
              ),
              Text(
                "All rights reserved  2024 ©".tr,
                style: const TextStyle(fontFamily: "Tajawal", fontSize: 12),
              ),
              (context.screenHeight * .03).kH,
              drawerContainer(
                context,
                "profile".tr,
                Icon(
                  Icons.person_2_outlined,
                  color: AppTheme.lightAppColors.primary,
                ),
                () {},
              ),
              (context.screenHeight * .02).kH,
              drawerContainer(
                context,
                "wallet".tr,
                Icon(
                  Icons.wallet,
                  color: AppTheme.lightAppColors.primary,
                ),
                () {},
              ),
              (context.screenHeight * .02).kH,
              drawerContainer(
                context,
                "SubscriptionNav".tr,
                Image.asset(
                  "assets/icon/Crown.webp",
                  width: 30,
                  colorBlendMode: BlendMode.darken,
                  color: AppTheme.lightAppColors.bordercolor.withOpacity(0.3),
                ),
                () {},
              ),
              (context.screenHeight * .02).kH,
              drawerContainer(
                context,
                "Terms".tr,
                Icon(
                  Icons.file_copy_outlined,
                  color: AppTheme.lightAppColors.primary,
                ),
                () {},
              ),
              (context.screenHeight * .02).kH,
              drawerContainer(
                context,
                "logout".tr,
                Icon(
                  Icons.person_2_outlined,
                  color: AppTheme.lightAppColors.primary,
                ),
                () {},
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: AppTheme.lightAppColors.background,
        child: const SafeArea(bottom: false, child: DashboradWidget()),
      ),
    );
  }

  drawerContainer(
      BuildContext context, title, Widget icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: context.screenWidth,
          height: context.screenHeight * .06,
          decoration: BoxDecoration(
              color: AppTheme.lightAppColors.primary.withOpacity(.05),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              icon,
              (context.screenHeight * .02).kW,
              Text(
                title,
                style: TextStyle(
                    color: AppTheme.lightAppColors.black,
                    fontFamily: "Inter",
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              )
            ],
          )),
    );
  }
}
