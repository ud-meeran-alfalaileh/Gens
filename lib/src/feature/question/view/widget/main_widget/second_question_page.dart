import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/question/controller/second_question_controller.dart'; // Updated controller import
import 'package:gens/src/feature/question/model/question_model.dart';
import 'package:gens/src/feature/question/view/widget/collection/second_display_page.dart';
import 'package:gens/src/feature/question/view/widget/text/question_text.dart';
import 'package:get/get.dart';

class SecondQuestionPageView extends StatefulWidget {
  const SecondQuestionPageView({super.key, required this.gender});
  final String gender;
  @override
  State<SecondQuestionPageView> createState() => _SecondQuestionPageViewState();
}

class _SecondQuestionPageViewState extends State<SecondQuestionPageView> {
  final SecondQuestionController controller =
      Get.put(SecondQuestionController());
  late PageController _pageController;
  int currentPage = 0;

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

  void nextPage() {
    print(controller.currentPage);
    if (_isCurrentPageAnswered()) {
      if (currentPage <
          (widget.gender == 'Male'
              ? controller.maleHormonalGi.length - 1
              : controller.femaleHormonalGi.length - 1)) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      Get.snackbar(
        'Incomplete',
        'Please answer the question before proceeding.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _isCurrentPageAnswered() {
    final question = widget.gender == 'Male'
        ? controller.maleHormonalGi[currentPage]
        : controller.femaleHormonalGi[currentPage];
    if (question.type == 'single') {
      return controller.selectedAnswers[question.name] != null;
    } else if (question.type == 'multiple') {
      return (controller.selectedAnswers[question.name] as List<String>?)
              ?.isNotEmpty ??
          false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: SafeArea(
        child: widget.gender == 'Male'
            ? Column(
                children: [
                  _buildHeader(context),
                  Text(
                    '${currentPage + 1} / ${controller.maleHormonalGi.length}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  20.0.kH,
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: controller.maleHormonalGi.length,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (page) {
                        setState(() {
                          currentPage = page;
                        });
                      },
                      itemBuilder: (context, index) {
                        final question = controller.maleHormonalGi[index];

                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                QuestionText.mainText(question.quesstion),
                                20.0.kH,
                                if (question.type == 'single')
                                  Obx(() =>
                                      _buildSingleQuestion(question, context)),
                                if (question.type == 'multiple')
                                  Obx(() => Column(
                                        children:
                                            question.answers.map((answer) {
                                          return _buildMultiQuestion(
                                              context, answer, question);
                                        }).toList(),
                                      )),
                                20.0.kH,
                                _buildButton(index, context),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  _buildHeader(context),
                  Text(
                    '${currentPage + 1} / ${controller.femaleHormonalGi.length}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  20.0.kH,
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: controller.femaleHormonalGi.length,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (page) {
                        setState(() {
                          currentPage = page;
                        });
                      },
                      itemBuilder: (context, index) {
                        final question = controller.femaleHormonalGi[index];

                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                QuestionText.mainText(question.quesstion),
                                20.0.kH,
                                if (question.type == 'single')
                                  Obx(() =>
                                      _buildSingleQuestion(question, context)),
                                if (question.type == 'multiple')
                                  Obx(() => Column(
                                        children:
                                            question.answers.map((answer) {
                                          return _buildMultiQuestion(
                                              context, answer, question);
                                        }).toList(),
                                      )),
                                20.0.kH,
                                _buildButton(index, context),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Row _buildButton(int index, BuildContext context) {
    return Row(
      mainAxisAlignment: index == 0
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      children: [
        if (index > 0)
          SizedBox(
            width: context.screenWidth * .3,
            child: AppButton(
              onTap: previousPage,
              title: 'Previous',
            ),
          ),
        if (index <
            (widget.gender == 'Male'
                ? controller.maleHormonalGi.length - 1
                : controller.femaleHormonalGi.length - 1))
          SizedBox(
            width: context.screenWidth * .3,
            child: AppButton(
              onTap: nextPage,
              title: 'Next',
            ),
          )
        else
          SizedBox(
            width: context.screenWidth * .3,
            child: AppButton(
              onTap: () {
                Get.to(() => SecResultsPage(
                      gender: widget.gender,
                    ));
              },
              title: 'Finish',
            ),
          ),
      ],
    );
  }

  Column _buildMultiQuestion(
      BuildContext context, String answer, QuestionModel question) {
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
                checkColor: Colors.white,
                activeColor: AppTheme.lightAppColors.primary,
                value:
                    (controller.selectedAnswers[question.name] as List<String>?)
                            ?.contains(answer) ??
                        false,
                onChanged: (isChecked) {
                  final selected = (controller.selectedAnswers[question.name]
                          as List<String>?) ??
                      [];

                  if (isChecked == true) {
                    selected.add(answer);
                  } else {
                    selected.remove(answer);
                  }
                  controller.selectMultipleAnswers(question.name, selected);
                },
              ),
            ],
          ),
        ),
        10.0.kH
      ],
    );
  }

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
            10.0.kH
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
                  value: (currentPage + 1) /
                      (widget.gender == "Male"
                          ? controller.maleHormonalGi.length
                          : controller.femaleHormonalGi.length),
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
