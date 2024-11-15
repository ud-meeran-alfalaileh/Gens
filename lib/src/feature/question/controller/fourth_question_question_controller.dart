import 'dart:convert';

import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/profile/controller/profile_controller.dart';
import 'package:gens/src/feature/question/model/question_model.dart';
import 'package:gens/src/feature/show_user/controller/show_user_controller.dart';
import 'package:get/get.dart';

class FourthQuestionController extends GetxController {
  RxBool isloading = false.obs;

  RxInt currentPage = 0.obs;
  User user = User();
  @override
  void onInit() {
    user.loadToken();
    super.onInit();
  }

  final profileController = Get.put(ProfileController());

  final List<QuestionModel> history = [
    QuestionModel(
      quesstion:
          'Have you ever taken the medication Isotretinoin for acne treatment? Commercial names include Roaccutane, Cureacne, Xeractan, Isosupra, etc',
      answers: ['Yes', 'No'],
      type: "single",
      name: "acneMedication",
      displayName: 'Isotretinoin',
    ),
    QuestionModel(
      quesstion:
          'Have you taken vitamin B12 pills or injections in the past three months?',
      answers: [
        'Yes',
        'No',
      ],
      type: "single",
      name: "b12Pills",
      displayName: 'vitamin B12',
    ),
  ];

  var selectedAnswers = <String, dynamic>{}.obs;

  void selectSingleAnswer(String questionName, String answer) {
    selectedAnswers[questionName] = answer;
  }

  void printFormattedAnswers() {
    final formattedAnswers = formatAnswersForApi();

    print('Formatted Answers:');
    formattedAnswers.forEach((questionName, answer) {
      print('$questionName: $answer');
    });
  }

  // Method to format answers for API
  Map<String, dynamic> formatAnswersForApi() {
    final formattedAnswers = <String, dynamic>{
      'userId': user.userId.value, // Ensure this is an integer
      'mainSkincareGoals': '',
      'acneMedication': '',
      'b12Pills': '',
    };

    selectedAnswers.forEach((questionName, answer) {
      String formattedAnswer;

      if (answer is List) {
        // Join list items with commas
        formattedAnswer = (answer).join(', ');
      } else {
        // Single answer as string
        formattedAnswer = answer.toString();
      }

      // Map question names to API keys
      switch (questionName) {
        case 'mainSkincareGoals': // Add this case for waterConsume
          formattedAnswers['mainSkincareGoals'] = formattedAnswer;
          break;
        case 'acneMedication':
          formattedAnswers['acneMedication'] = formattedAnswer;
          break;
        case 'b12Pills':
          formattedAnswers['b12Pills'] = formattedAnswer;
          break;

        default:
          print('Unhandled question name: $questionName');
          break;
      }
    });

    return formattedAnswers;
  }

  void debugPrintAnswers() {
    printFormattedAnswers();
  }

  void selectMultipleAnswers(String questionName, List<String> answers) {
    selectedAnswers[questionName] = answers;
  }

  Future<void> fourthQuestionApi() async {
    isloading.value = true;

    try {
      final formattedAnswers = formatAnswersForApi();
      print('Formatted Answers: $formattedAnswers'); // Debug print

      final body = jsonEncode(formattedAnswers);
      final response = await dioConsumer.post(EndPoints.fourthPage, body: body);

      if (response.statusCode == StatusCode.ok) {
        await profileController.getQuestionDetails();
        profileController.isFifthDataIncomplete.value = false;

        Get.back();
        Get.back();
        await profileController.getQuestionDetails();
        profileController.isFifthDataIncomplete.value = false;
      }
      isloading.value = false;
    } catch (e) {
      isloading.value = false;
      print(e);
    }
  }
}
