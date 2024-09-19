import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gens/src/config/sizes/short_text.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/loading_page.dart';
import 'package:gens/src/feature/doctor_profile/model/doctor_model.dart';
import 'package:gens/src/feature/vendor_history/view/page/vendor_history_page.dart';
import 'package:gens/src/feature/vendor_profile/controller/vendor_profile_controller.dart';
import 'package:gens/src/feature/vendor_profile/view/widget/main_widget/vendor_pationt.dart';
import 'package:gens/src/feature/vendor_profile/view/widget/main_widget/vendor_update_profile.dart';
import 'package:gens/src/feature/vendor_profile/view/widget/main_widget/vendor_update_time.dart';
import 'package:gens/src/feature/vendor_profile/view/widget/text/vendor_profile_text.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class VendorProfileWidget extends StatefulWidget {
  const VendorProfileWidget({super.key});

  @override
  State<VendorProfileWidget> createState() => _VendorProfileWidgetState();
}

class _VendorProfileWidgetState extends State<VendorProfileWidget> {
  final controller = Get.put(VendorProfileController());
  final PageController _pageController = PageController();

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
    final user = controller.vendor.value;

// Split the string at " - "

// Access the start and end times

    return SafeArea(
      child: controller.isLoading.value
          ? loadingPage(context)
          : SingleChildScrollView(
              child: Obx(
                () => controller.isLoading.value
                    ? loadingPage(context)
                    : Column(
                        children: [
                          SizedBox(
                              height: context.screenHeight * .35,
                              child: vendorHeader(context, user)),
                          20.0.kH,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              vendorProfileContainer(
                                  context,
                                  'assets/image/information.png',
                                  "Information", () {
                                Get.to(() => const VendorUpdateProfile());
                              }),
                              vendorProfileContainer(context,
                                  'assets/image/people.png', "Patients", () {
                                Get.to(() => const VendorPationt());
                              }),
                            ],
                          ),
                          TextButton(
                              onPressed: () {
                                controller.logout();
                              },
                              child: Text("child")),
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
                                VendorProfileText.timeText(user.workingTime),
                                10.0.kH,
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: VendorProfileText.thirdText(
                                      user.description),
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
                                  "Working Hours", () {
                                Get.to(() => const VendorHistoryPage());
                              }),
                              vendorProfileContainer(
                                  context, 'assets/image/back-in-time.png', "",
                                  () {
                                Get.to(() => const VendorUpdateTime());
                              }),
                            ],
                          ),
                          60.0.kH,
                        ],
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
                child: PageView.builder(
                  controller: _pageController, // Attach PageController
                  itemCount: controller.imageUrls.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      child: Container(
                        width: context.screenWidth,
                        height: context.screenHeight * .13,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(controller.imageUrls[index]),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            : const Center(child: Text("No images available")),

        // Page Indicator (Dots)

        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(20.0), // Adjust bottom padding
            child: SmoothPageIndicator(
              controller: _pageController,
              count: controller.imageUrls.length,
              effect: ExpandingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                activeDotColor:
                    AppTheme.lightAppColors.primary, // Active dot color
                dotColor:
                    AppTheme.lightAppColors.maincolor, // Inactive dot color
                expansionFactor: 3, // Expands active dot
                spacing: 8, // Spacing between dots
              ),
            ),
          ),
        ),

        // Bottom overlay with vendor info and rating
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(10),
            width: context.screenWidth * .8,
            height: context.screenHeight * .1,
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
            child: Row(
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
          ),
        ),
      ],
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
