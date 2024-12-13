import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/question/controller/first_question_controller.dart';
import 'package:get/get.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key, required this.gender, required this.from});
  final String from;
  final String gender;

  @override
  Widget build(BuildContext context) {
    final FirstQuestionController controller =
        Get.find<FirstQuestionController>();

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
                          // height: context.screenHeight * .3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: AppTheme.lightAppColors.background,
                              border: Border.all(
                                  color: AppTheme.lightAppColors.bordercolor)),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: controller.selectedAnswers.length,
                            itemBuilder: (context, index) {
                              // Retrieve the question name (key)
                              final questionName = controller
                                  .selectedAnswers.keys
                                  .elementAt(index);
                              final answer =
                                  controller.selectedAnswers[questionName];

                              // Find the matching QuestionModel from the skinType list based on the name
                              final questionModel =
                                  controller.skinType.firstWhere(
                                (element) => element.name == questionName,
                              );

                              // Use displayName instead of name
                              String questionDisplayName =
                                  questionModel.displayName;

                              // Format answer (handle single or multiple answers)
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: context.screenWidth * .36,
                                        child: Text(
                                          questionDisplayName, // Use displayName here
                                          style: TextStyle(
                                            color:
                                                AppTheme.lightAppColors.black,
                                            fontFamily: "Inter",
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                          ),
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
                          ))),
                      20.0.kH,
                      AppButton(
                          onTap: () {
                            controller.firstQuestionApi(gender,from);
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
