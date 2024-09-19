import 'dart:convert';

import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/question/model/question_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SkinQoalController extends GetxController {
  RxInt currentPage = 0.obs;
  User user = User();

  @override
  void onInit() {
    user.loadToken();
    super.onInit();
  }

  final List<QuestionModel> skinGoalQuestions = [
    QuestionModel(
      quesstion: "What are your main skincare goals?",
      answers: [
        'Clear acne',
        'Reduce redness',
        'Even out skin tone',
        'Hydrate skin',
        'Minimize pores',
        'Improve overall skin health'
      ],
      type: "single",
      name: "mainSkincareGoals",
    ),
    QuestionModel(
      quesstion: 'Do you regularly use sunscreen?',
      answers: ['Yes', 'No'],
      type: "single",
      name: "sunscreenUsage",
    ),
    // Add more questions as needed
  ];

  var selectedAnswers = <String, dynamic>{}.obs;

  void selectSingleAnswer(String questionName, String answer) {
    selectedAnswers[questionName] = answer;
  }

  void selectMultipleAnswers(String questionName, List<String> answers) {
    selectedAnswers[questionName] = answers;
  }

  void printFormattedAnswers() {
    final formattedAnswers = formatAnswersForApi();
    print('Formatted Answers: $formattedAnswers');
  }

  String formatAnswersForApi() {
    // Assuming you only have one question to handle.
    final questionName = 'mainSkincareGoals';

    // Get the formatted answer
    final answer = selectedAnswers[questionName];

    if (answer is List) {
      return (answer).join(', ');
    } else {
      return answer.toString();
    }
  }

  Future<void> submitSkinGoals() async {
    try {
      final formattedAnswer =
          jsonEncode(formatAnswersForApi()); // Get the answer as a string
      print('Formatted Answer: $formattedAnswer');

      final response = await http.post(
        Uri.parse("${EndPoints.skinGoals}${user.userId}"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: formattedAnswer,
      );

      print('Request Body: $formattedAnswer');
      print('Response: ${response.body}');
      print('Status Code: ${response.statusCode}');
      if (response.statusCode == StatusCode.ok) {
        // Navigate to the next page or show a success message
        Get.back();
      }
    } catch (e) {
      print(e);
    }
  }
}
