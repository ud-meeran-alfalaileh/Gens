import 'dart:convert';

import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/profile/controller/profile_controller.dart';
import 'package:gens/src/feature/question/model/question_model.dart';
import 'package:gens/src/feature/question/view/widget/main_widget/fourth_question_page.dart';
import 'package:gens/src/feature/show_user/controller/show_user_controller.dart';
import 'package:get/get.dart';

class ThirdQuestionController extends GetxController {
  final profileController = Get.put(ProfileController());
  RxBool isloading = false.obs;

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
      displayName: 'Water consume',
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
      displayName: 'Sleep',
    ),
    QuestionModel(
      quesstion: "How often do you exercise?",
      answers: ['Every day', 'A few times a week', 'Rarely', 'Never'],
      type: "single",
      name: "ExerciseRoutine",
      displayName: 'Exercies',
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
      displayName: 'Smoking status',
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
      displayName: 'Stress level',
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
      displayName: 'Stress manage',
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

  Future<void> thirdQuestionApi(from) async {
    isloading.value = true;

    try {
      final formattedAnswers = formatAnswersForApi();
      print('Formatted Answers: $formattedAnswers'); // Debug print

      final body = jsonEncode(formattedAnswers);
      final response = await dioConsumer.post(EndPoints.thirdPage, body: body);

      if (response.statusCode == StatusCode.ok) {
        await profileController.getQuestionDetails();
        from == 'Update'
            ? {Get.back()}
            : Get.off(() => FourthQuestionPageView(from: from));
      }
      isloading.value = false;
    } catch (e) {
      isloading.value = false;
      print(e);
    }
  }
}
