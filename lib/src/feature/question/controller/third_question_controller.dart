import 'dart:convert';

import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/profile/controller/profile_controller.dart';
import 'package:gens/src/feature/question/model/question_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ThirdQuestionController extends GetxController {
  final profileController = Get.put(ProfileController());

  RxInt currentPage = 0.obs;
  User user = User();
  @override
  void onInit() {
    user.loadToken();
    super.onInit();
  }

  final List<QuestionModel> lifestyle = [
    QuestionModel(
      quesstion: "How much water do you drink daily?",
      answers: [
        'Less than 1 liter',
        '1-2 liters',
        'More than 2 liters',
      ],
      type: "single",
      name: "waterConsume",
    ),
    QuestionModel(
      quesstion: 'How many hours of sleep do you get each night?',
      answers: [
        'Less than 5 hours',
        '5-7 hours',
        '7-9 hours',
        'More than 9 hours'
      ],
      type: "single",
      name: "sleepingHours",
    ),
    QuestionModel(
      quesstion: "How often do you exercise?",
      answers: ['Every day', 'A few times a week', 'Rarely', 'Never'],
      type: "single",
      name: "ExerciseRoutine",
    ),
    QuestionModel(
      quesstion: "What is your smoking status?",
      answers: [
        'Smoker (hookah or cigarettes)',
        'I live surrounded by smokers',
        'I do not smoke or live with smokers',
      ],
      type: "single",
      name: "smokingStatus",
    ),
    QuestionModel(
      quesstion: 'How would you rate your stress levels?',
      answers: [
        'High',
        'Moderate',
        'Low',
        'None',
      ],
      type: "single",
      name: "stressLevel",
    ),
    QuestionModel(
      quesstion: "What do you do to manage stress?",
      answers: [
        'Exercise',
        'Meditation/Yoga',
        'Hobbies (reading, music, etc.)',
        'Talking to friends/family',
        'Other'
      ],
      type: "multiple",
      name: "manageStress",
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
      'waterConsume': '',
      'sleepingHours': '',
      'ExerciseRoutine': '',
      'smokingStatus': '',
      'stressLevel': '',
      'manageStress': '',
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
        case 'waterConsume': // Add this case for waterConsume
          formattedAnswers['waterConsume'] = formattedAnswer;
          break;
        case 'sleepingHours':
          formattedAnswers['sleepingHours'] = formattedAnswer;
          break;
        case 'ExerciseRoutine':
          formattedAnswers['ExerciseRoutine'] = formattedAnswer;
          break;
        case 'smokingStatus':
          formattedAnswers['smokingStatus'] = formattedAnswer;
          break;
        case 'stressLevel':
          formattedAnswers['stressLevel'] = formattedAnswer;
          break;
        case 'manageStress':
          formattedAnswers['manageStress'] = formattedAnswer;
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

  Future<void> thirdQuestionApi() async {
    try {
      final formattedAnswers = formatAnswersForApi();
      print('Formatted Answers: $formattedAnswers'); // Debug print

      final body = jsonEncode(formattedAnswers);
      final response = await http.post(Uri.parse(EndPoints.thirdPage),
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
        await profileController.getQuestionDetails();
        Get.back();
        Get.back();
      }
    } catch (e) {
      print(e);
    }
  }
}
