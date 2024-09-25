import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/forgtet_password/controller/forget_password_controller.dart';
import 'package:gens/src/feature/forgtet_password/view/widget/text/forget_password_text.dart';
import 'package:gens/src/feature/login/model/login_form_model.dart';
import 'package:gens/src/feature/login/view/widgte/collection/auth_form_widget.dart';
import 'package:get/get.dart';

class ForgetPasswrodForm extends StatelessWidget {
  const ForgetPasswrodForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: Obx(
        () => Stack(
          children: [
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: controller.fromKeyOne,
                  child: Column(
                    children: [
                      100.0.kH,
                      ForgetPasswordText.mainText("Enter New password".tr),
                      20.0.kH,
                      AuthForm(
                        formModel: FormModel(
                            icon: Icons.lock_outline,
                            controller: controller.password,
                            enableText: false,
                            hintText: "loginPassword".tr,
                            invisible: true,
                            validator: (v) => controller.vaildPassword(v!),
                            type: TextInputType.text,
                            inputFormat: [],
                            onTap: () {}),
                      ),
                      20.0.kH,
                      AuthForm(
                        formModel: FormModel(
                            icon: Icons.lock_outline,
                            controller: controller.confirmPassword,
                            enableText: false,
                            hintText: "confirmPassword".tr,
                            invisible: true,
                            validator: (v) =>
                                controller.validConfirmPassword(v!),
                            type: TextInputType.text,
                            inputFormat: [],
                            onTap: () {}),
                      ),
                      30.0.kH,
                      AppButton(
                          onTap: () {
                            if (controller.fromKeyOne.currentState!
                                .validate()) {
                              controller.resetPassword();
                            }
                          },
                          title: "Continue")
                    ],
                  ),
                ),
              ),
            ),
            controller.isLoading.value
                ? Container(
                    width: context.screenWidth,
                    height: context.screenHeight,
                    color: AppTheme.lightAppColors.black.withOpacity(0.1),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.lightAppColors.primary,
                      ),
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
