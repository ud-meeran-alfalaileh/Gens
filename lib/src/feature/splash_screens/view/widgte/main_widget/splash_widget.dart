import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/nav_bar/view/main/navbar_page.dart';
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
    return Column(
      children: [
        SizedBox(
          height: context.screenHeight * .8,
          child: PageView(
            controller: controller.pageController,
            onPageChanged: (index) {
              controller.currentPageIndex.value = index;
            },
            children: <Widget>[
              pageOne(
                "assets/image/splash1.png",
                "Meet Doctors Online",
                "Connect with Specialized Doctors Online for Convenient andl Comprehensive Medical Consultations.",
                context,
              ),
              pageOne(
                "assets/image/splash2.png",
                "Meet Doctors Online",
                "Connect with Specialized Doctors Online for Convenient and Comprehensive Medical Consultations.",
                context,
              ),
              pageOne(
                "assets/image/splash3.png",
                "Thousands of Online Specialists",
                "Connect with Specialized Doctors Online for Convenient and Comprehensive Medical Consultations.",
                context,
              ),
            ],
          ),
        ),
        splashButton(context),
        (context.screenHeight * .01).kH,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 25),
              height: 25,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Obx(
                    () => Container(
                      width:
                          controller.currentPageIndex.value == index ? 35 : 20,
                      height: 10,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 3),
                      decoration: BoxDecoration(
                          color: controller.currentPageIndex.value == index
                              ? AppTheme.lightAppColors.primary
                              : AppTheme.lightAppColors.bordercolor,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  );
                },
                itemCount: 3,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => {
            Get.to(() => const NavBarPage(currentScreen: 0,)),
            controller.completeOnboarding()
          },
          child: SplashText.secText("Skip"),
        )
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            height: context.screenHeight * .63,
            width: context.screenWidth,
            child: Image.asset(
              image,
              fit: BoxFit.cover,
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              20.0.kH,
              SplashText.mainText(title),
              10.0.kH,
              SplashText.secText(description),
            ],
          ),
        )
      ],
    );
  }
}
