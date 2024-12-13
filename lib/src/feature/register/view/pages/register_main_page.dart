import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/dashboard/view/widget/text/dashboard_text.dart';
import 'package:gens/src/feature/register/view/pages/register_page.dart';
import 'package:gens/src/feature/register_vendor/view/page/vendor_register_page.dart';
import 'package:gens/src/feature/vendor_dashboard/view/widget/text/vendor_dashboard_text.dart';
import 'package:get/get.dart';

class RegisterMainPage extends StatelessWidget {
  const RegisterMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    RxBool selectedUser = false.obs;
    RxBool selectedVendor = false.obs;
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: Container(
        color: AppTheme.lightAppColors.secondaryColor,
        child: SafeArea(
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
                  Row(
                    children: [
                      VendorDashboardText.registerText("Register as:".tr),
                    ],
                  ),
                  30.0.kH,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          selectedUser.value = true;
                          selectedVendor.value = false;
                          // Get.to(() => const RegisterPage());
                        },
                        child: Obx(
                          () => AnimatedContainer(
                            constraints: BoxConstraints(
                                minHeight: context.screenHeight * .32),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 40),
                            width: context.screenWidth * .43,
                            decoration: BoxDecoration(
                              color: selectedUser.value
                                  ? AppTheme.lightAppColors.bordercolor
                                  : AppTheme.lightAppColors.background,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            duration: const Duration(milliseconds: 300),
                            child: Column(
                              children: [
                                TweenAnimationBuilder(
                                  tween: Tween<double>(
                                    begin: selectedUser.value ? 0.0 : 1.0,
                                    end: selectedUser.value ? 1.0 : 0.0,
                                  ),
                                  duration: const Duration(milliseconds: 300),
                                  builder: (context, double value, child) {
                                    return Transform(
                                      transform:
                                          Matrix4.rotationY(value * 3.14159),
                                      alignment: Alignment.center,
                                      child: child,
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/image/user.png',
                                    width: context.screenWidth * .3,
                                  ),
                                ),
                                15.0.kH,
                                DashboardText.mainText("User".tr)
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          selectedUser.value = false;
                          selectedVendor.value = true;
                          //
                        },
                        child: Obx(
                          () => AnimatedContainer(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 40),
                            width: context.screenWidth * .43,
                            constraints: BoxConstraints(
                                minHeight: context.screenHeight * .32),
                            decoration: BoxDecoration(
                              color: selectedVendor.value
                                  ? AppTheme.lightAppColors.bordercolor
                                  : AppTheme.lightAppColors.background,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            duration: const Duration(milliseconds: 300),
                            child: Column(
                              children: [
                                TweenAnimationBuilder(
                                  tween: Tween<double>(
                                    begin: selectedVendor.value ? 0.0 : 1.0,
                                    end: selectedVendor.value ? 1.0 : 0.0,
                                  ),
                                  duration: const Duration(milliseconds: 300),
                                  builder: (context, double value, child) {
                                    return Transform(
                                      transform:
                                          Matrix4.rotationY(value * 3.14159),
                                      alignment: Alignment.center,
                                      child: child,
                                    );
                                  },
                                  child: Image.asset(
                                    'assets/image/doctor-coat.png',
                                    width: context.screenWidth * .3,
                                  ),
                                ),
                                15.0.kH,
                                DashboardText.mainText("Clinic".tr)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  (context.screenHeight * .2).kH,
                  Obx(() => selectedVendor.value || selectedUser.value
                      ? AppButton(
                          onTap: () {
                            selectedVendor.value
                                ? Get.to(() => const VendorRegisterPage())
                                : Get.to(() => const RegisterPage());
                          },
                          title: "Next")
                      : const SizedBox.shrink())
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
