import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/forgtet_password/controller/forget_password_controller.dart';
import 'package:gens/src/feature/forgtet_password/view/widget/main_widget/otp_widget.dart';
import 'package:gens/src/feature/forgtet_password/view/widget/text/forget_password_text.dart';
import 'package:gens/src/feature/login/model/login_form_model.dart';
import 'package:gens/src/feature/login/view/widgte/collection/auth_form_widget.dart';
import 'package:get/get.dart';

class ForgetPasswordWidget extends StatelessWidget {
  const ForgetPasswordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: controller.fromKey,
        child: Column(
          children: [
            (context.screenHeight * .05).kH,
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back_ios))
              ],
            ),
            (context.screenHeight * .1).kH,
            ForgetPasswordText.mainText(
              'Forget Password? '.tr,
            ),
            10.0.kH,
            ForgetPasswordText.secText(
                "Enter your Email, we will send you a verification code.".tr),
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

                      if (controller.errorText.value == "valid") {
                        Get.to(() => const OtpWidget());
                      }
                    },
                    title: "send".tr))
          ],
        ),
      ),
    );
  }
}
