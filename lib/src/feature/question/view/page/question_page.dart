import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/profile/controller/profile_controller.dart';
import 'package:gens/src/feature/question/controller/add_image_user_controller.dart';
import 'package:gens/src/feature/question/controller/first_question_controller.dart';
import 'package:gens/src/feature/question/view/widget/collection/add_image.dart';
import 'package:gens/src/feature/question/view/widget/collection/add_product_widget.dart';
import 'package:gens/src/feature/question/view/widget/main_widget/first_qustion_widget.dart';
import 'package:gens/src/feature/question/view/widget/main_widget/fourth_question_page.dart';
import 'package:gens/src/feature/question/view/widget/main_widget/second_question_page.dart';
import 'package:gens/src/feature/question/view/widget/main_widget/skin_qoal_page.dart';
import 'package:gens/src/feature/question/view/widget/main_widget/third_question_page.dart';
import 'package:gens/src/feature/question/view/widget/text/question_text.dart';
import 'package:get/get.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({super.key, required this.gender});
  final String gender;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FirstQuestionController());
    final profileController = Get.put(ProfileController());
    final imageController = Get.put(AddImageUserController());

    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: Obx(
        () => Stack(
          children: [
            controller.show.value
                ? GestureDetector(
                    onTap: () {
                      controller.show.value = false;
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: context.screenWidth,
                      height: context.screenHeight,
                      decoration: BoxDecoration(
                          color: AppTheme.lightAppColors.maincolor),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            DelayedDisplay(
                              delay: const Duration(milliseconds: 200),
                              child: Image.asset(
                                'assets/image/build.png',
                                width: context.screenWidth * .4,
                              ),
                            ),
                            20.0.kH,
                            DelayedDisplay(
                                delay: const Duration(milliseconds: 400),
                                child: QuestionText.secText(
                                    "Tap To Start Building Your Profile")),
                            50.0.kH,
                          ],
                        ),
                      ),
                    ),
                  )
                : SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon: const Icon(Icons.arrow_back_ios))
                              ],
                            ),
                            20.0.kH,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Obx(
                                  () => Stack(
                                    children: [
                                      sectionButton(context, "Skin Type", () {
                                        Get.to(() => FirstQuestionPageView(
                                              gender: widget.gender,
                                            ));
                                      }, 50),
                                      profileController
                                              .isFirstDataIncomplete.value
                                          ? const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            )
                                          : const SizedBox.shrink()
                                    ],
                                  ),
                                ),
                                Obx(
                                  () => Stack(
                                    children: [
                                      sectionButton(context, 'Hormonal & GI',
                                          () {
                                        Get.to(() => SecondQuestionPageView(
                                              gender: widget.gender,
                                            ));
                                      }, 100),
                                      profileController
                                              .isSecDataIncomplete.value
                                          ? const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            )
                                          : const SizedBox.shrink()
                                    ],
                                  ),
                                )
                              ],
                            ),
                            20.0.kH,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Obx(
                                  () => Stack(
                                    children: [
                                      sectionButton(context, "Life Style", () {
                                        Get.to(() =>
                                            const ThirdQuestionPageView());
                                      }, 150),
                                      profileController
                                              .isThirdDataIncomplete.value
                                          ? const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            )
                                          : const SizedBox.shrink()
                                    ],
                                  ),
                                ),
                                Obx(
                                  () => Stack(
                                    children: [
                                      sectionButton(context, "History cheack",
                                          () {
                                        Get.to(() =>
                                            const FourthQuestionPageView());
                                      }, 250),
                                      profileController
                                              .isFifthDataIncomplete.value
                                          ? const Icon(
                                              Icons.error,
                                              color: Colors.red,
                                            )
                                          : const SizedBox.shrink()
                                    ],
                                  ),
                                )
                              ],
                            ),
                            20.0.kH,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Stack(
                                  children: [
                                    sectionButton(context, "Skin Goals", () {
                                      Get.to(() =>
                                          const SkinQoalQuestionPageView());
                                    }, 200),
                                    profileController
                                            .isFourthDataIncomplete.value
                                        ? const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          )
                                        : const SizedBox.shrink()
                                  ],
                                ),
                                Stack(
                                  children: [
                                    sectionButton(context, "Face Image", () {
                                      Get.to(() => const UserThreeImage());
                                    }, 300),
                                    imageController.isImageDataIncomplere.value
                                        ? const Icon(
                                            Icons.error,
                                            color: Colors.red,
                                          )
                                        : const SizedBox.shrink()
                                  ],
                                )
                              ],
                            ),
                            20.0.kH,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: context.screenWidth * .4,
                                  height: context.screenHeight * .18,
                                  child: Stack(
                                    children: [
                                      sectionButton(context, "Product", () {
                                        Get.to(() => const AddProductWidget());
                                      }, 350),
                                    ],
                                  ),
                                ),
                                // productController.isProductIncomplete.value
                                //     ? const Icon(
                                //         Icons.error,
                                //         color: Colors.red,
                                //       )
                                //     : const SizedBox.shrink()
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }

  sectionButton(BuildContext context, title, VoidCallback ontap, duration) {
    return DelayedDisplay(
      delay: Duration(milliseconds: duration),
      child: GestureDetector(
        onTap: ontap,
        child: Container(
          width: context.screenWidth * .4,
          height: context.screenHeight * .18,
          decoration: BoxDecoration(
              border: Border.all(color: AppTheme.lightAppColors.maincolor),
              borderRadius: BorderRadius.circular(20),
              color: AppTheme.lightAppColors.maincolor.withOpacity(0.8)),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  color: AppTheme.lightAppColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
