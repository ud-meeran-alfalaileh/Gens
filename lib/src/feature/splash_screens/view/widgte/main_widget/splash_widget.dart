import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/splash_screens/controller/spalsh_controller.dart';
import 'package:gens/src/feature/splash_screens/view/widgte/text/splash_text.dart';
import 'package:get/get.dart';

class SplashWidget extends StatefulWidget {
  const SplashWidget({super.key});

  @override
  State<SplashWidget> createState() => _SplashWidgetState();
}

class _SplashWidgetState extends State<SplashWidget> {
  late SpalshController controller;

  @override
  void initState() {
    controller = Get.put(SpalshController());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: context.screenHeight,
          child: PageView(
            controller: controller.pageController,
            onPageChanged: (index) {
              controller.currentPageIndex.value =
                  index; // Update current page index
            },
            children: <Widget>[
              pageOne(
                "assets/image/splash1.png",
                "Meet Doctors Online",
                "Connect with Specialized Doctors Online for Convenient and Comprehensive Medical Consultations.",
                context,
              ),
              pageOne(
                "assets/image/splash2.png",
                "Meet Doctors Online",
                "Connect with Specialized Doctors Online for Convenient and Comprehensive Medical Consultations.",
                context,
              ),
              pageOne(
                "assets/image/splash3.jpg",
                "Thousands of Online Specialists",
                "Connect with Specialized Doctors Online for Convenient and Comprehensive Medical Consultations.",
                context,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: context.screenHeight * .1,
          child: Container(
            height: context.screenHeight * .3,
            width: context.screenWidth,
            decoration: BoxDecoration(
              color: AppTheme.lightAppColors.background.withOpacity(0.6),
            ),
            child: Obx(() {
              // Dynamically update content based on current page
              final currentIndex = controller.currentPageIndex.value;
              String title = '';
              String description = '';

              switch (currentIndex) {
                case 0:
                  title = "Meet Doctors Online";
                  description =
                      "Connect with Specialized Doctors Online for Convenient and Comprehensive Medical Consultations.";
                  break;
                case 1:
                  title = "Meet Doctors Online";
                  description =
                      "Connect with Specialized Doctors Online for Convenient and Comprehensive Medical Consultations.";
                  break;
                case 2:
                  title = "Thousands of Online Specialists";
                  description =
                      "Connect with Specialized Doctors Online for Convenient and Comprehensive Medical Consultations.";
                  break;
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  20.0.kH,
                  SplashText.mainText(title),
                  10.0.kH,
                  SplashText.secText(description),
                  splashButton(context),
                  (context.screenHeight * .01).kH,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(
                      3,
                      (index) => Obx(
                        () => Container(
                          width: controller.currentPageIndex.value == index
                              ? 35
                              : 20,
                          height: 10,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 3),
                          decoration: BoxDecoration(
                            color: controller.currentPageIndex.value == index
                                ? AppTheme.lightAppColors.primary
                                : AppTheme.lightAppColors.bordercolor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Row splashButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () {
              controller.nextPage();
            },
            child: Container(
              width: 0.7 * context.screenWidth,
              height: 0.05 * context.screenHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppTheme.lightAppColors.primary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SplashText.thirdText(
                    "Next",
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container sliderTextWidget(title, secTitle) {
    return Container(
      padding: const EdgeInsets.only(right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SplashText.mainText(title),
          5.0.kH,
          SplashText.secText(secTitle),
        ],
      ),
    );
  }

  pageOne(image, title, description, BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: context.screenHeight,
          width: context.screenWidth,
          child: Image.asset(
            image,
            fit: BoxFit.fitHeight,
          ),
        ),
      ],
    );
  }
}
