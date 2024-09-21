import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/question/controller/skin_qoal_controller.dart';
import 'package:gens/src/feature/question/model/question_model.dart';
import 'package:gens/src/feature/question/view/widget/text/question_text.dart';
import 'package:get/get.dart';

class SkinQoalQuestionPageView extends StatefulWidget {
  const SkinQoalQuestionPageView({super.key});

  @override
  State<SkinQoalQuestionPageView> createState() =>
      _SkinQoalQuestionPageViewState();
}

class _SkinQoalQuestionPageViewState extends State<SkinQoalQuestionPageView> {
  final SkinQoalController controller = Get.put(SkinQoalController());
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            const Text(
              '1 / 1',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            20.0.kH,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    QuestionText.mainText(
                        controller.skinGoalQuestions[0].quesstion),
                    20.0.kH,
                    Obx(() => _buildQuestionWidget(
                        controller.skinGoalQuestions[0], context)),
                    20.0.kH,
                    _buildButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: context.screenWidth * .3,
          child: AppButton(
            onTap: controller.submitSkinGoals,
            title: 'Next',
          ),
        ),
      ],
    );
  }

  // Determines whether to build single (radio) or multiple (checkbox) question
  Widget _buildQuestionWidget(QuestionModel question, BuildContext context) {
    if (question.type == 'single') {
      return _buildSingleQuestion(question, context);
    } else if (question.type == 'multiple') {
      return _buildMultiQuestion(question, context);
    }
    return Container();
  }

  // Widget for single-choice questions using Radio
  Column _buildSingleQuestion(QuestionModel question, BuildContext context) {
    return Column(
      children: question.answers.map((answer) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              width: context.screenWidth,
              height: context.screenHeight * .08,
              decoration: BoxDecoration(
                color: AppTheme.lightAppColors.maincolor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(answer),
                    Radio<String>(
                      focusColor: AppTheme.lightAppColors.primary,
                      activeColor: AppTheme.lightAppColors.primary,
                      value: answer,
                      groupValue:
                          controller.selectedAnswers[question.name] as String?,
                      onChanged: (value) {
                        controller.selectSingleAnswer(question.name, value!);
                      },
                    ),
                  ]),
            ),
            10.0.kH,
          ],
        );
      }).toList(),
    );
  }

  // Widget for multiple-choice questions using Checkbox
  Column _buildMultiQuestion(QuestionModel question, BuildContext context) {
    return Column(
      children: question.answers.map((answer) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              width: context.screenWidth,
              height: context.screenHeight * .08,
              decoration: BoxDecoration(
                color: AppTheme.lightAppColors.maincolor,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(answer),
                    Checkbox(
                      checkColor: Colors.white, // color of tick mark
                      activeColor: AppTheme.lightAppColors.primary,
                      value: (controller.selectedAnswers[question.name]
                                  as List<String>?)
                              ?.contains(answer) ??
                          false,
                      onChanged: (isChecked) {
                        final selected =
                            (controller.selectedAnswers[question.name]
                                    as List<String>?) ??
                                [];
                        if (isChecked == true) {
                          selected.add(answer);
                        } else {
                          selected.remove(answer);
                        }
                        controller.selectMultipleAnswers(
                            question.name, selected);
                      },
                    ),
                  ]),
            ),
            10.0.kH,
          ],
        );
      }).toList(),
    );
  }

  Row _buildHeader(BuildContext context) {
    return Row(
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
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                width: context.screenWidth * .7,
                child: LinearProgressIndicator(
                  value: 1.0,
                  borderRadius: BorderRadius.circular(10),
                  color: AppTheme.lightAppColors.primary,
                  backgroundColor:
                      AppTheme.lightAppColors.primary.withOpacity(0.2),
                  minHeight: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
