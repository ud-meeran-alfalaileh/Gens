import 'dart:convert';

import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/question/model/question_model.dart';
import 'package:gens/src/feature/question/view/widget/main_widget/second_question_page.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FirstQuestionController extends GetxController {
  RxBool show = true.obs;

  RxInt currentPage = 0.obs;
  User user = User();
  @override
  void onInit() {
    user.loadToken();
    super.onInit();
  }

  final List<QuestionModel> skinType = [
    QuestionModel(
      quesstion:
          "How would you categorize your skin type after cleansing and waiting 2 hours or first thing in the morning?",
      answers: ['Oily', 'Dry', 'Combination', 'Normal', 'I am not sure'],
      type: "single",
      name: "skinTypeMorning",
    ),
    QuestionModel(
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
      quesstion:
          "How would you categorize your skin type after cleansing and waiting 2 hours or first thing in the morning?",
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
        formattedAnswer = (answer as List<dynamic>).join(', ');
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
    try {
      final formattedAnswers = formatAnswersForApi();
      print('Formatted Answers: $formattedAnswers'); // Debug print

      final body = jsonEncode(formattedAnswers);
      final response = await http.post(Uri.parse(EndPoints.firstPage),
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
        Get.offAll(() => SecondQuestionPageView(
              gender: gender,
            ));
      }
    } catch (e) {
      print(e);
    }
  }
}
