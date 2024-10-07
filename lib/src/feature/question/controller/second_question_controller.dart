import 'dart:convert';

import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/profile/controller/profile_controller.dart';
import 'package:gens/src/feature/question/model/question_model.dart';
import 'package:gens/src/feature/show_user/controller/show_user_controller.dart';
import 'package:get/get.dart';

class SecondQuestionController extends GetxController {
  final profileController = Get.put(ProfileController());
  RxBool isloading = false.obs;

  RxInt currentPage = 0.obs;
  User user = User();
  @override
  void onInit() {
    user.loadToken();
    super.onInit();
  }

  final List<QuestionModel> femaleHormonalGi = [
    QuestionModel(
      quesstion: "What is your marital status?",
      answers: ['Single', 'Married', 'Divorced', 'Widowed'],
      type: "single",
      name: "maritalStatus",
      displayName: 'Marital status',
    ),
    QuestionModel(
        quesstion:
            "Do you have regular periods (your menstrual cycle is every 21 to 35 days)?",
        answers: [
          'Yes',
          'No',
        ],
        type: "single",
        name: "femalePeriodType",
        gender: "Female",
        displayName: 'Having regular periods'),
    QuestionModel(
        quesstion:
            "Do you have any hormone-related issues or conditions (e.g., PCOS)?",
        answers: [
          'Yes',
          'No',
        ],
        type: "single",
        name: "HormoneRelated",
        gender: "Female",
        displayName: 'Hormone-related issues'),
    QuestionModel(
      quesstion: "Which of the following foods do you consume daily?",
      answers: [
        'Whole milk',
        'Low-fat or skim milk',
        'Dairy products (cheese, labneh,etc..)',
        'Carbonated drinks (diet or regular)',
        'Cookies/Chocolate/Cake',
        'Chips or fried potatoes',
        'Fast foods ',
        'Fruits and Vegetables',
      ],
      type: "multiple",
      name: "foodConsume",
      displayName: 'Food consume',
    ),
    QuestionModel(
      quesstion: "Which of the following issues do you frequently experience?",
      answers: [
        'Diarrhea',
        'Constipation',
        'Bloating',
        'Abdominal pain',
        "None of the above",
      ],
      type: "multiple",
      name: "issuesFrequentlyExperience",
      displayName: 'Issue',
    ),
  ];
  final List<QuestionModel> maleHormonalGi = [
    QuestionModel(
      quesstion: "What is your marital status?",
      answers: ['Single', 'Married', 'Divorced', 'Widowed'],
      type: "single",
      name: "maritalStatus",
      displayName: 'Marital status',
    ),
    QuestionModel(
      quesstion: "Which of the following foods do you consume daily?",
      answers: [
        'Whole milk',
        'Low-fat or skim milk',
        'Dairy products (cheese, labneh,etc..)',
        'Carbonated drinks (diet or regular)',
        'Cookies/Chocolate/Cake',
        'Chips or fried potatoes',
        'Fast foods ',
        'Fruits and Vegetables',
      ],
      type: "multiple",
      name: "foodConsume",
      displayName: 'Food consume',
    ),
    QuestionModel(
      quesstion: "Which of the following issues do you frequently experience?",
      answers: [
        'Diarrhea',
        'Constipation',
        'Bloating',
        'Abdominal pain',
        "None of the above",
      ],
      type: "multiple",
      name: "issuesFrequentlyExperience",
      displayName: 'Issue',
    ),
  ];

  var selectedAnswers = <String, dynamic>{}.obs;

  void selectSingleAnswer(String questionName, String answer) {
    selectedAnswers[questionName] = answer;
  }

  void printFormattedAnswers(gender) {
    final formattedAnswers = formatAnswersForApi(gender);

    print('Formatted Answers:');
    formattedAnswers.forEach((questionName, answer) {
      print('$questionName: $answer');
    });
  }

  // Method to format answers for API
  Map<String, dynamic> formatAnswersForApi(String gender) {
    print("Gender: $gender");

    // Initialize formatted answers with default values
    final formattedAnswers = <String, dynamic>{
      'userId': user.userId.value, // Ensure this is an integer
      'maritalStatus': '',
      'foodConsume': '',
      'issuesFrequentlyExperience': '',
    };

    // Only include female-related fields if the gender is female
    if (gender == 'Female') {
      formattedAnswers['femalePeriodType'] = '';
      formattedAnswers['femaleHormoneRelated'] = '';
    }

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
        case 'maritalStatus':
          formattedAnswers['maritalStatus'] = formattedAnswer;
          break;
        case 'foodConsume':
          formattedAnswers['foodConsume'] = formattedAnswer;
          break;
        case 'issuesFrequentlyExperience':
          formattedAnswers['issuesFrequentlyExperience'] = formattedAnswer;
          break;
        // Correct female-related question names to match exactly with the QuestionModel names
        case 'femalePeriodType': // Corrected
          formattedAnswers['femalePeriodType'] = formattedAnswer;
          break;
        case 'HormoneRelated': // Corrected
          formattedAnswers['femaleHormoneRelated'] = formattedAnswer;
          break;
        default:
          print('Unhandled question name: $questionName');
          break;
      }
    });

    return formattedAnswers;
  }

  void selectMultipleAnswers(String questionName, List<String> answers) {
    selectedAnswers[questionName] = answers;
  }

  Future<void> secQuestionApi(gender) async {
    isloading.value = true;

    try {
      final formattedAnswers = formatAnswersForApi(gender);
      print('Formatted Answers: $formattedAnswers'); // Debug print

      final body = jsonEncode(formattedAnswers);
      final response = await dioConsumer.post(EndPoints.secPage, body: body);

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
