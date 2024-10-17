import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gens/src/core/api/api_services.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/injection_container.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/feature/profile/model/question_model.dart';
import 'package:gens/src/feature/profile/model/user_model.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;

final DioConsumer dioConsumer = sl<DioConsumer>();

class ShowUserController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<SkinCareModel?> question = Rx<SkinCareModel?>(null);
  var updatedImage = Rx<File?>(null);
  RxList<String> imageUrls = List<String>.filled(3, '').obs;
  var message = TextEditingController();
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
      final response = await dioConsumer.get("${EndPoints.getUser}/$id");
      print(response.data);
      if (response.statusCode == StatusCode.ok) {
        final data = jsonDecode(response.data);

        userData.value = UserModel.fromJson(data);
        print(userData.value);
        final age = calculateAge(userData.value!.dateOfBirth);
        calculatedAge.value = age;
        isLoading.value = false;
      }
    } catch (e) {
      print(e);
        isLoading.value = false;

    }
  }

  Future<void> getProduct(userId) async {
    isLoading.value = true;
    final response =
        await dioConsumer.get('${EndPoints.getProductDetail}$userId');
    print(response.data);
    if (response.statusCode == StatusCode.ok) {
      var data = jsonDecode(response.data);
      isLoading.value = true;

      if (data != null) {
        message.text = data['productDescription'] ?? '';

        // Update the image field (this assumes the image URL is in the response)
        if (data['productImage'] != null && data['productImage'].isNotEmpty) {
          updatedImage.value = await downloadImage(data['productImage']);
        } else {}
        isLoading.value = false;
      }
    } else {
      // Handle error
      print('Failed to get product: ${response.statusCode}');
    }
  }

  Future<File> downloadImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    final tempDir = Directory.systemTemp;
    final file =
        File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<void> getQuestionDetails(id) async {
    isLoading.value = true;
    try {
      final response = await dioConsumer.get(
    "${EndPoints.getQuestion}/$id"
      );
    
      if (response.statusCode == StatusCode.ok) {
        final data = jsonDecode(response.data);
        question.value = SkinCareModel.fromJson(data);
      } else {
        final data = jsonDecode(response.data)['message'];
        if (data == "Questionnaire not found for the given user.") {}
      }

      isLoading.value = F;
    } catch (e) {
      print(e);
    }
  }

  RxBool isImageDataIncomplere = false.obs;

  Future<void> getUserthreeImage(userId) async {
    String apiUrl =
        'https://gts-b8dycqbsc6fqd6hg.uaenorth-01.azurewebsites.net/api/UserImages/$userId';
    try {
      isLoading.value = true;
      final response = await dioConsumer.get(
      apiUrl,
        
      );
      print(response.data);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.data);

        // Update imageUrls with the URLs from the response
        imageUrls[0] = responseData['userImage1'] ?? '';
        imageUrls[1] = responseData['userImage2'] ?? '';
        imageUrls[2] = responseData['userImage3'] ?? '';
        isImageDataIncomplere.value = imageUrls[0].isEmpty ? true : false;
        isLoading.value = false;
      } else {
        print('The image is empty');
        isLoading.value = false;
        isImageDataIncomplere.value = true;
      }
    } catch (e) {
      print(e);
      isLoading.value = false;
    }
  }
}
