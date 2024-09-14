import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/loading_page.dart';
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
    await controller.getVendorsById();
    Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final user = controller.vendor.value;
    String timeRange = user!.workingTime;

// Split the string at " - "
    List<String> times = timeRange.split(" - ");

// Access the start and end times
    String startTime = times[0]; // "10:00"
    String endTime = times[1]; // "17:00"
    return SafeArea(
      child: SingleChildScrollView(
        child: Obx(
          () => controller.isLoading.value
              ? loadingPage(context)
              : Column(
                  children: [
                    SizedBox(
                      height: context.screenHeight * .35,
                      child: Stack(
                        children: [
                          SizedBox(
                            child: Container(
                              width: context.screenWidth,
                              height: context.screenHeight * .3,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    user.businessImages.first.imgUrl1),
                              )),
                            ),
                          ),
                          Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  width: context.screenWidth * .8,
                                  height: context.screenHeight * .1,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color:
                                          AppTheme.lightAppColors.background),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      VendorProfileText.mainText(
                                          'Israa Elshebli'),
                                      const Spacer(),
                                      SvgPicture.asset(
                                        "assets/image/ratingStar.svg",
                                        height: 16,
                                      ),
                                      5.0.kW,
                                      VendorProfileText.ratingText(
                                          user.avgRating.toString()),
                                    ],
                                  )))
                        ],
                      ),
                    ),
                    20.0.kH,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        vendorProfileContainer(context,
                            'assets/image/information.png', "Information", () {
                          Get.to(() => const VendorUpdateProfile());
                        }),
                        vendorProfileContainer(
                            context, 'assets/image/people.png', "Patients", () {
                          Get.to(() => const VendorPationt());
                        }),
                      ],
                    ),
                    20.0.kH,
                    Container(
                      padding: const EdgeInsets.all(18),
                      width: context.screenWidth * .9,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppTheme.lightAppColors.maincolor),
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          20.0.kW,
                          VendorProfileText.timeText(
                              'Starts at $startTime and ends at $endTime'),
                          10.0.kH,
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: VendorProfileText.thirdText(
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ...'),
                          ),
                        ],
                      ),
                    ),
                    20.0.kH,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        vendorProfileContainer(
                            context,
                            'assets/image/back-in-time.png',
                            "Working Hours",
                            () {}),
                        vendorProfileContainer(context,
                            'assets/image/back-in-time.png', "", () {}),
                      ],
                    ),
                    60.0.kH,
                  ],
                ),
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
