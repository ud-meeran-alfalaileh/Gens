import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gens/src/config/sizes/short_text.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/loading_page.dart';
import 'package:gens/src/feature/doctor_profile/model/doctor_model.dart';
import 'package:gens/src/feature/profile/view/widget/collection/vendor_profile_row.dart';
import 'package:gens/src/feature/vendor_history/view/page/vendor_history_page.dart';
import 'package:gens/src/feature/vendor_profile/controller/vendor_profile_controller.dart';
import 'package:gens/src/feature/vendor_profile/view/widget/main_widget/vendor_pationt.dart';
import 'package:gens/src/feature/vendor_profile/view/widget/main_widget/vendor_update_profile.dart';
import 'package:gens/src/feature/vendor_profile/view/widget/text/vendor_profile_text.dart';
import 'package:get/get.dart';

class VendorProfileWidget extends StatefulWidget {
  const VendorProfileWidget({super.key});

  @override
  State<VendorProfileWidget> createState() => _VendorProfileWidgetState();
}

class _VendorProfileWidgetState extends State<VendorProfileWidget> {
  final controller = Get.put(VendorProfileController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initail();
    });
    super.initState();
  }

  Future<void> initail() async {
    Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
// Split the string at " - "

// Access the start and end times

    return SafeArea(
      child: SingleChildScrollView(
        child: Obx(
          () => controller.isLoading.value
              ? loadingPage(context)
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                          child:
                              vendorHeader(context, controller.vendor.value)),
                      profileContainerRow(controller),
                      Container(
                        color: const Color(0xfff5f5f5),
                        width: context.screenWidth,
                        height: context.screenHeight,
                        child: Obx(() {
                          switch (controller.selectedIndex.value) {
                            case 0:
                              return const VendorUpdateProfile();
                            case 1:
                              return const SizedBox(
                                  height: 20, child: VendorPationt());

                            default:
                              return Container();
                          }
                        }),
                      ),
                      20.0.kH,
                      100.0.kH,
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Stack vendorHeader(BuildContext context, DoctorModelById user) {
    return Stack(
      children: [
        // Image slider
        controller.imageUrls.isNotEmpty
            ? SizedBox(
                height: context.screenHeight * .3,
                child: SizedBox(
                  child: Container(
                    width: context.screenWidth,
                    height: context.screenHeight * .13,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(controller.imageUrls[0]),
                      ),
                    ),
                  ),
                ))
            : const Center(child: Text("No images available")),

        Container(
          width: context.screenWidth,
          height: context.screenHeight * .3,
          color: AppTheme.lightAppColors.black.withOpacity(0.3),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 70.0, left: 35, right: 35),
          child: Container(
            padding: const EdgeInsets.all(10),
            width: context.screenWidth * .8,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightAppColors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 1),
                ),
              ],
              borderRadius: BorderRadius.circular(15),
              color: AppTheme.lightAppColors.background,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VendorProfileText.mainText(user.name),
                    const Spacer(),
                    SvgPicture.asset(
                      "assets/image/ratingStar.svg",
                      height: 16,
                    ),
                    const SizedBox(width: 5),
                    VendorProfileText.ratingText(
                        storyShortenText(user.avgRating.toString())),
                  ],
                ),
                const Divider(),
                VendorProfileText.thirdText(user.type),
                VendorProfileText.thirdText(user.phone),
                VendorProfileText.thirdText(user.location),
              ],
            ),
          ),
        ),
      ],
    );
  }

  profileContainerRow(VendorProfileController controller) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            VendorProfileRow(
              onTap: () {
                controller.setSelectedIndex(0);
              },
              isSelected: controller.selectedIndex.value == 0,
              title: "Profile Details".tr,
            ),
            VendorProfileRow(
              onTap: () {
                controller.setSelectedIndex(1);
              },
              isSelected: controller.selectedIndex.value == 1,
              title: 'Pationt Details'.tr,
            ),
            VendorProfileRow(
              onTap: () {
                Get.to(const VendorHistoryPage(),
                    transition: Transition.downToUp);
              },
              isSelected: controller.selectedIndex.value == 2,
              title: 'history'.tr,
            ),
            VendorProfileRow(
              onTap: () {
                controller.logout();
              },
              isSelected: controller.selectedIndex.value == 3,
              title: 'logout'.tr,
            ),
          ],
        ),
      ),
    );
  }

  vendorProfileContainer(BuildContext context, img, title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: context.screenWidth * .4,
        height: context.screenHeight * .2,
        decoration: BoxDecoration(
            color: AppTheme.lightAppColors.maincolor.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              img,
              width: context.screenWidth * .15,
            ),
            20.0.kH,
            VendorProfileText.secText(title)
          ],
        ),
      ),
    );
  }
}
