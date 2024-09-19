import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/question/controller/first_question_controller.dart';
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
                                sectionButton(context, "Skin Type", () {
                                  Get.to(() => FirstQuestionPageView(
                                        gender: widget.gender,
                                      ));
                                }, 50),
                                sectionButton(context, "Hermonal & GI", () {
                                  Get.to(() => SecondQuestionPageView(
                                        gender: widget.gender,
                                      ));
                                }, 100),
                              ],
                            ),
                            20.0.kH,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                sectionButton(context, "Life Style", () {
                                  Get.to(() => const ThirdQuestionPageView());
                                }, 150),
                                sectionButton(context, "History cheack", () {
                                  Get.to(() => const FourthQuestionPageView());
                                }, 250),
                              ],
                            ),
                            20.0.kH,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                sectionButton(context, "Skin Goals", () {
                                  Get.to(
                                      () => const SkinQoalQuestionPageView());
                                }, 200),
                                sectionButton(context, "Skin Type", () {}, 300),
                              ],
                            ),
                            20.0.kH,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                sectionButton(context, "Skin Type", () {}, 350),
                                sectionButton(context, "Skin Type", () {}, 400),
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
