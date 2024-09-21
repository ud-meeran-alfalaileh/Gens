import 'dart:convert';

import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/feature/profile/model/question_model.dart';
import 'package:gens/src/feature/profile/model/user_model.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;

class ShowUserController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<SkinCareModel?> question = Rx<SkinCareModel?>(null);

  Rx<UserModel?> userData = UserModel(
          userId: 0,
          dateOfBirth: "password",
          email: "email",
          fName: "fName",
          secName: "secName",
          phone: "phone",
          gender: "gender",
          userType: "userType",
          userImage: "")
      .obs;
  RxInt calculatedAge = 0.obs;
  int calculateAge(String dateOfBirth) {
    DateTime birthDate = DateTime.parse(dateOfBirth);
    DateTime today = DateTime.now();
    int age = today.year - birthDate.year;

    // Adjust the age if the birthday hasn't occurred yet this year
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  Future<void> getUser(id) async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse("${EndPoints.getUser}/$id"),
        headers: {
          'Content-Type':
              'application/json', // This should match the API's expected content type
          'Accept': 'application/json',
        },
      );
      print(response.body);
      if (response.statusCode == StatusCode.ok) {
        final data = jsonDecode(response.body);

        userData.value = UserModel.fromJson(data);
        print(userData.value);
        final age = calculateAge(userData.value!.dateOfBirth);
        calculatedAge.value = age;
        isLoading.value = false;
      }
    } catch (e) {
      print(e);
      // showSnackBar("Error", e, Colors.red);
    }
  }

  Future<void> getQuestionDetails(id) async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse("${EndPoints.getQuestion}/$id"),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == StatusCode.ok) {
        final data = jsonDecode(response.body);
        question.value = SkinCareModel.fromJson(data);
      } else {
        final data = jsonDecode(response.body)['message'];
        if (data == "Questionnaire not found for the given user.") {}
      }

      isLoading.value = F;
    } catch (e) {
      print(e);
    }
  }
}
