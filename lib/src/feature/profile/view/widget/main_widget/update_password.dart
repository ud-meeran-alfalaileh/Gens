import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_auth_button.dart';
import 'package:gens/src/feature/login/model/login_form_model.dart';
import 'package:gens/src/feature/login/view/widgte/collection/auth_form_widget.dart';
import 'package:gens/src/feature/profile/controller/profile_controller.dart';
import 'package:gens/src/feature/profile/view/widget/text/password_text.dart';
import 'package:get/get.dart';

class UpdatePassword extends StatelessWidget {
  const UpdatePassword({super.key});

  @override
  Widget build(BuildContext context) {
    // RxBool seeOldPassword = false.obs;
    // RxBool seeNewPassword = false.obs;
    // RxBool seeConfirmPassword = false.obs;
    final controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: controller.passwordFromKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: AppTheme.lightAppColors.primary,
                        ))
                  ],
                ),
                (context.screenHeight * .05).kH,
                PasswordText.mainText("Forget Password".tr),
                7.0.kH,
                PasswordText.secText(
                    "No worries! Enter your old password below".tr),
                (context.screenHeight * .06).kH,
                Obx(() {
                  return controller.errorText.value != "valid"
                      ? Row(
                          children: [
                            Text(
                              controller.errorText.value,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14.0),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        )
                      : const SizedBox.shrink();
                }),
                Stack(
                  children: [
                    AuthForm(
                      formModel: FormModel(
                          controller: controller.oldPassword,
                          enableText: false,
                          hintText: "oldPassword".tr,
                          invisible: true,
                          validator: null,
                          icon: Icons.lock_open_rounded,
                          type: TextInputType.text,
                          inputFormat: [],
                          onTap: () {}),
                    ),
                  ],
                ),
                20.0.kH,
                Stack(
                  children: [
                    AuthForm(
                      formModel: FormModel(
                          controller: controller.newPassword,
                          enableText: false,
                          hintText: "newPassowrd".tr,
                          invisible: true,
                          icon: Icons.lock,
                          validator: null,
                          type: TextInputType.text,
                          inputFormat: [],
                          onTap: () {}),
                    ),
                  ],
                ),
                20.0.kH,
                Stack(
                  children: [
                    AuthForm(
                      formModel: FormModel(
                          controller: controller.confirmPassword,
                          enableText: false,
                          hintText: "confirmPassword".tr,
                          invisible: true,
                          validator: null,
                          icon: Icons.lock,
                          type: TextInputType.text,
                          inputFormat: [],
                          onTap: () {}),
                    ),
                  ],
                ),
                40.0.kH,
                SizedBox(
                    width: 200,
                    child: AppAuthButton(
                        onTap: () async {
                          controller.errorText.value =
                              controller.validateAllFields()!;

                          if (controller.errorText.value == "valid") {
                            await controller.updtaePassword(context);
                          }
                        },
                        title: "Confirm".tr))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
