import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  final email = TextEditingController();
  final password = TextEditingController();
  final fromKey = GlobalKey<FormState>();
  String? pageOneValidateAllFields() {
    RxList<String?> errors = <String>[].obs;
    vaildEmail(String? email) {
      if (!GetUtils.isEmail(email!)) {
        return "EmailValidate".tr;
      }
      return null;
    }

    // Validate each form field and collect errors
    final nameError = vaildEmail(email.text);

    if (nameError != null) errors.add("- $nameError");

    if (errors.isNotEmpty) {
      return errors.first;
    }
    return "valid";
  }

  RxString errorText = "".obs;

  // Future<void> updatePassword ()async{
  //   final response  = await http.post(url)
  // }
}
