import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/question/controller/first_question_controller.dart';
import 'package:gens/src/feature/question/model/question_model.dart';
import 'package:gens/src/feature/question/view/widget/collection/display_page.dart';
import 'package:gens/src/feature/question/view/widget/text/question_text.dart';
import 'package:get/get.dart';

class FirstQuestionPageView extends StatefulWidget {
  const FirstQuestionPageView({super.key, required this.gender,required this.from,});
  final String from;
  final String gender;

  @override
  State<FirstQuestionPageView> createState() => _FirstQuestionPageViewState();
}

class _FirstQuestionPageViewState extends State<FirstQuestionPageView> {
  final FirstQuestionController controller = Get.put(FirstQuestionController());
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

  // Function to navigate to the next page
  void nextPage() {
    if (_isCurrentPageAnswered()) {
      if (currentPage < controller.skinType.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } else {
      // Show an alert or a snackbar to infrom the user to answer the question
      Get.snackbar(
        'Incomplete',
        'Please answer the question before proceeding.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.lightAppColors.secondaryColor,
        colorText: Colors.white,
      );
    }
  }

  // Function to navigate to the previous page
  void previousPage() {
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Check if the current page has been answered
  bool _isCurrentPageAnswered() {
    final question = controller.skinType[currentPage];
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
        child: Column(
          children: [
            // Progress bar and navigation
            _buildHeader(context),
            Text(
              '${currentPage + 1} / ${controller.skinType.length}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            20.0.kH,
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: controller.skinType.length,
                physics:
                    const NeverScrollableScrollPhysics(), // Disable swiping
                onPageChanged: (page) {
                  setState(() {
                    currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  final question = controller.skinType[index];

                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        QuestionText.mainText(question.quesstion),
                        20.0.kH,
                        if (question.type == 'single')
                          Obx(() => _buildSingleQuestion(question, context)),
                        if (question.type == 'multiple')
                          Obx(() => Column(
                                children: question.answers.map((answer) {
                                  return _buildMultiQuestion(
                                      context, answer, question);
                                }).toList(),
                              )),
                        20.0.kH,
                        _buildButton(index, context),
                      ],
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
        if (index > 0) // Show previous button if not on first page
          SizedBox(
            width: context.screenWidth * .3,
            child: AppButton(
              onTap: previousPage,
              title: 'Previous',
            ),
          ),
        if (index == 0 &&
            controller.skinType.length >
                1) // Center "Next" button if it's the first page
          Expanded(
            child: Center(
              child: SizedBox(
                width: context.screenWidth * .3,
                child: AppButton(
                  onTap: nextPage,
                  title: 'Next',
                ),
              ),
            ),
          )
        else if (index <
            controller.skinType.length -
                1) // Show next button if not on last page
          SizedBox(
            width: context.screenWidth * .3,
            child: AppButton(
              onTap: nextPage,
              title: 'Next',
            ),
          )
        else // Show Finish button on the last page
          SizedBox(
            width: context.screenWidth * .3,
            child: AppButton(
              onTap: () {
                Get.off(() => ResultsPage(
                      gender: widget.gender, from: widget.from,
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
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
          width: context.screenWidth,
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
                activeColor: AppTheme.lightAppColors.secondaryColor,
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
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
              width: context.screenWidth,
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
                      activeColor: AppTheme.lightAppColors.secondaryColor,
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                width: context.screenWidth * .7,
                child: LinearProgressIndicator(
                  value: (currentPage + 1) / controller.skinType.length,
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
