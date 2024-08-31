import 'package:flutter/material.dart';
import 'package:gens/src/feature/login/model/login_form_model.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/feature/login/view/widgte/collection/auth_form_widget.dart';
import 'package:gens/src/feature/register/controller/register_controller.dart';

class RegisterFormContainer extends StatefulWidget {
  const RegisterFormContainer({super.key});

  @override
  State<RegisterFormContainer> createState() => _RegisterFormContainerState();
}

class _RegisterFormContainerState extends State<RegisterFormContainer> {
  final registerController = Get.put(RegisterController());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        children: [
          (20.0).kH,
          AuthForm(
            formModel: FormModel(
              controller: registerController.name,
              enableText: false,
              hintText: "الاسم",
              invisible: F,
              validator: null,
              type: TextInputType.text,
              inputFormat: [],
              onTap: () {},
            ),
          ),
          (20.0).kH,
          AuthForm(
            formModel: FormModel(
              controller: registerController.email,
              enableText: false,
              hintText: "الابريد الالكتروني",
              invisible: F,
              validator: null,
              type: TextInputType.text,
              inputFormat: [],
              onTap: () {},
            ),
          ),
          (20.0).kH,
          AuthForm(
            formModel: FormModel(
              controller: registerController.phoneNumber,
              enableText: false,
              hintText: "رقم الهاتف",
              invisible: F,
              validator: null,
              type: TextInputType.text,
              inputFormat: [],
              onTap: () {},
            ),
          ),
          (20.0).kH,
          AuthForm(
            formModel: FormModel(
              controller: registerController.password,
              enableText: false,
              hintText: "الباسورد",
              invisible: true,
              validator: null,
              type: TextInputType.text,
              inputFormat: [],
              onTap: () {},
            ),
          ),
          (20.0).kH,
          AuthForm(
            formModel: FormModel(
              controller: registerController.confirmPassword,
              enableText: false,
              hintText: "Confirm password",
              invisible: true,
              validator: null,
              type: TextInputType.text,
              inputFormat: [],
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
