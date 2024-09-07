import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/feature/login/model/login_form_model.dart';
import 'package:gens/src/feature/login/view/widgte/collection/auth_form_widget.dart';
import 'package:gens/src/feature/profile/controller/profile_controller.dart';
import 'package:get/get.dart';

class UpdateProfileWidget extends StatelessWidget {
  const UpdateProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Email"),
            AuthForm(
                formModel: FormModel(
                    controller: controller.email,
                    enableText: false,
                    hintText: "Email",
                    invisible: false,
                    validator: null,
                    type: TextInputType.emailAddress,
                    inputFormat: [],
                    onTap: null)),
            (15.0.kH),
            const Text("First Name"),
            AuthForm(
                formModel: FormModel(
                    controller: controller.name,
                    enableText: false,
                    hintText: "Firs Name",
                    invisible: false,
                    validator: null,
                    type: TextInputType.text,
                    inputFormat: [],
                    onTap: null)),
            (15.0.kH),
            const Text("Second Name"),
            AuthForm(
                formModel: FormModel(
                    controller: controller.secName,
                    enableText: false,
                    hintText: "Second Name",
                    invisible: false,
                    validator: null,
                    type: TextInputType.text,
                    inputFormat: [],
                    onTap: null)),
            (15.0.kH),
            const Text("Email"),
            AuthForm(
                formModel: FormModel(
                    controller: controller.phoneNumber,
                    enableText: false,
                    hintText: "Email",
                    invisible: false,
                    validator: null,
                    type: TextInputType.text,
                    inputFormat: [],
                    onTap: null)),
            (15.0.kH),
            const Text("Email"),
            AuthForm(
                formModel: FormModel(
                    controller: controller.email,
                    enableText: false,
                    hintText: "Email",
                    invisible: false,
                    validator: null,
                    type: TextInputType.text,
                    inputFormat: [],
                    onTap: null)),
            (15.0.kH),
            const Text("Email"),
            AuthForm(
                formModel: FormModel(
                    controller: controller.email,
                    enableText: false,
                    hintText: "Email",
                    invisible: false,
                    validator: null,
                    type: TextInputType.text,
                    inputFormat: [],
                    onTap: null)),
            (15.0.kH),
            const Text("Email"),
            AuthForm(
                formModel: FormModel(
                    controller: controller.email,
                    enableText: false,
                    hintText: "Email",
                    invisible: false,
                    validator: null,
                    type: TextInputType.text,
                    inputFormat: [],
                    onTap: null)),
            (15.0.kH),
          ],
        ),
      ),
    );
  }
}
