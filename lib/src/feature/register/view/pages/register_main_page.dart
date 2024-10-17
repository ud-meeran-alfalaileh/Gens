import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/dashboard/view/widget/text/dashboard_text.dart';
import 'package:gens/src/feature/register/view/pages/register_page.dart';
import 'package:gens/src/feature/register_vendor/view/page/vendor_register_page.dart';
import 'package:gens/src/feature/vendor_dashboard/view/widget/text/vendor_dashboard_text.dart';
import 'package:get/get.dart';

class RegisterMainPage extends StatelessWidget {
  const RegisterMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(Icons.arrow_back_ios_new,
                            color: AppTheme.lightAppColors.black))
                  ],
                ),
                100.0.kH,
                VendorDashboardText.registerText("Register as:".tr),
                30.0.kH,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const RegisterPage());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: context.screenWidth * .43,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppTheme.lightAppColors.primary,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/image/user.png',
                              width: context.screenWidth * .3,
                            ),
                            15.0.kH,
                            DashboardText.mainText("User".tr)
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => const VendorRegisterPage());
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        width: context.screenWidth * .43,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: AppTheme.lightAppColors.primary,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/image/clinic.png',
                              width: context.screenWidth * .3,
                            ),
                            15.0.kH,
                            DashboardText.mainText("Clinic".tr)
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
