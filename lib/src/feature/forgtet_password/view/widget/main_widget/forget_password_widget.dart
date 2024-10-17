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

class ForgetPasswordWidget extends StatelessWidget {
  const ForgetPasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Obx(
      () => Form(
        key: controller.fromKey,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  (context.screenHeight * .05).kH,
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.arrow_back_ios))
                    ],
                  ),
                  (context.screenHeight * .1).kH,
                  ForgetPasswordText.mainText(
                    "Forgot password?".tr,
                  ),
                  10.0.kH,
                  ForgetPasswordText.secText(
                      "Enter your Email, we will send you a verification code."
                          .tr),
                  Obx(() {
                    return controller.errorText.value != "" &&
                            controller.errorText.value != "valid"
                        ? Column(
                            children: [
                              (context.screenHeight * .04).kH,
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  children: [
                                    Text(
                                      controller.errorText.value,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 14.0),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : (context.screenHeight * .072).kH;
                  }),
                  AuthForm(
                    formModel: FormModel(
                        icon: Icons.email_outlined,
                        controller: controller.email,
                        enableText: false,
                        hintText: 'loginEmail'.tr,
                        invisible: false,
                        validator: null,
                        type: TextInputType.text,
                        inputFormat: [],
                        onTap: () {}),
                  ),
                  (context.screenHeight * .04).kH,
                  SizedBox(
                      width: context.screenWidth * .7,
                      child: AppButton(
                          onTap: () {
                            controller.errorText.value =
                                controller.pageOneValidateAllFields()!;
                            controller.nEmail.value =
                                controller.email.text.trim();
                            if (controller.errorText.value == "valid") {
                              controller.sendEmail(context);
                            }
                          },
                          title: "send".tr))
                ],
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
