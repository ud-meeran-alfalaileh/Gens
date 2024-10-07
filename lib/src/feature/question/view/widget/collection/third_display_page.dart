import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/question/controller/third_question_controller.dart';
import 'package:get/get.dart';

class ThirdDisplayPage extends StatelessWidget {
  const ThirdDisplayPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThirdQuestionController controller =
        Get.find<ThirdQuestionController>();

    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.maincolor,
      body: SafeArea(
        child: Obx(
          () => controller.isloading.value
              ? Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.lightAppColors.primary,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          color: AppTheme.lightAppColors.primary,
                        ),
                      ),
                      const Text(
                        'Your Answers:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Obx(() => Container(
                            padding: const EdgeInsets.all(20),
                            width: context.screenWidth,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: AppTheme.lightAppColors.background,
                                border: Border.all(
                                    color:
                                        AppTheme.lightAppColors.bordercolor)),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: controller.selectedAnswers.length,
                              itemBuilder: (context, index) {
                                final questionName = controller
                                    .selectedAnswers.keys
                                    .elementAt(index);
                                final answer =
                                    controller.selectedAnswers[questionName];

                                // Find the matching QuestionModel based on the questionName
                                final questionModel =
                                    controller.lifestyle.firstWhere(
                                  (element) => element.name == questionName,
                                );

                                // Use displayName if it exists, otherwise fallback to questionName
                                final displayName = questionModel.displayName;

                                // Format the answer (single or multiple answers)
                                String answerText;
                                if (answer is List) {
                                  answerText = answer.join(', ');
                                } else {
                                  answerText = answer.toString();
                                }

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          displayName, // Use displayName here
                                          style: TextStyle(
                                            color:
                                                AppTheme.lightAppColors.black,
                                            fontFamily: "Inter",
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        20.0.kW,
                                        SizedBox(
                                          width: context.screenWidth * .35,
                                          child: Text(
                                            answerText,
                                            style: TextStyle(
                                              color:
                                                  AppTheme.lightAppColors.black,
                                              fontFamily: "Inter",
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    20.0.kH,
                                  ],
                                );
                              },
                            ),
                          )),
                      20.0.kH,
                      AppButton(
                          onTap: () {
                            controller.thirdQuestionApi();
                          },
                          title: "Next")
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
