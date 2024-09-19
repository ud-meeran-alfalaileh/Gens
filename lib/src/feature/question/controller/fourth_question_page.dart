import 'dart:convert';

import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/question/model/question_model.dart';
import 'package:gens/src/feature/question/view/widget/main_widget/skin_qoal_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FourthQuestionController extends GetxController {
  RxInt currentPage = 0.obs;
  User user = User();
  @override
  void onInit() {
    user.loadToken();
    super.onInit();
  }

  final List<QuestionModel> history = [
    QuestionModel(
      quesstion:
          'Have you ever taken the medication Isotretinoin for acne treatment? Commercial names include Roaccutane, Cureacne, Xeractan, Isosupra, etc',
      answers: ['Yes', 'No'],
      type: "single",
      name: "acneMedication",
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
        formattedAnswer = (answer as List<dynamic>).join(', ');
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
    try {
      final formattedAnswers = formatAnswersForApi();
      print('Formatted Answers: $formattedAnswers'); // Debug print

      final body = jsonEncode(formattedAnswers);
      final response = await http.post(Uri.parse(EndPoints.fourthPage),
          headers: {
            'Content-Type':
                'application/json', // This should match the API's expected content type
            'Accept': 'application/json',
          },
          body: body);

      print('Request Body: $body');
      print('Response: ${response.body}');
      print('Status Code: ${response.statusCode}');
      if (response.statusCode == StatusCode.ok) {
        Get.offAll(() => const SkinQoalQuestionPageView());
      }
    } catch (e) {
      print(e);
    }
  }
}
