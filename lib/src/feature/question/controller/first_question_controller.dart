import 'dart:convert';

import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/profile/controller/profile_controller.dart';
import 'package:gens/src/feature/question/model/question_model.dart';
import 'package:gens/src/feature/show_user/controller/show_user_controller.dart';
import 'package:get/get.dart';

class FirstQuestionController extends GetxController {
  RxBool show = true.obs;
  final profileController = Get.put(ProfileController());
  RxBool isloading = false.obs;
  RxInt currentPage = 0.obs;
  User user = User();
  @override
  void onInit() {
    user.loadToken();
    super.onInit();
  }

  final List<QuestionModel> skinType = [
    QuestionModel(
      displayName: "Skin Type",
      quesstion:
          "How would you categorize your skin type after cleansing and waiting 2 hours or first thing in the morning?",
      answers: ['Oily', 'Dry', 'Combination', 'Normal', 'I am not sure'],
      type: "single",
      name: "skinTypeMorning",
    ),
    QuestionModel(
      displayName: "Skin Concerns",
      quesstion: "Do you experience any of these skin concerns?",
      answers: [
        'Acne',
        'Blackheads/Whiteheads',
        'Redness',
        'Fine Lines',
        'Dullness',
        'Large Pores'
      ],
      type: "multiple",
      name: "skinConcerns",
    ),
    QuestionModel(
      displayName: "Skin Concerns",
      quesstion: "Do you experience any of the following skin issues?",
      answers: [
        'Itching sensation',
        'Stinging sensation',
        'Burning sensation',
        'Tight skin',
        'Reacts easily to new products',
        'None of the above'
      ],
      type: "multiple",
      name: "skinIssue",
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
      'skinTypeMorning': '',
      'skinConcerns': '',
      'skinIssue': '',
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
        case 'skinTypeMorning':
          formattedAnswers['skinTypeMorning'] = formattedAnswer;
          break;
        case 'skinConcerns':
          formattedAnswers['skinConcerns'] = formattedAnswer;
          break;
        case 'skinIssue':
          formattedAnswers['skinIssue'] = formattedAnswer;
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

  Future<void> firstQuestionApi(gender) async {
    isloading.value = true;
    try {
      final formattedAnswers = formatAnswersForApi();
      print('Formatted Answers: $formattedAnswers'); // Debug print

      final body = jsonEncode(formattedAnswers);
      final response = await dioConsumer.post(EndPoints.firstPage, body: body);
      print(response.data);
      if (response.statusCode == StatusCode.ok) {
        await profileController.getQuestionDetails();
        Get.back();
        Get.back();
      }
      isloading.value = false;
    } catch (e) {
      isloading.value = false;

      print(e);
    }
  }
}
