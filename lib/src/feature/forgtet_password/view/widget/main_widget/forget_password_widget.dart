import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
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
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          (context.screenHeight * .15).kH,
          ForgetPasswordText.mainText("Forget Password?"),
          10.0.kH,
          ForgetPasswordText.secText(
              "Enter your Email, we will send you a verification code."),
          (context.screenHeight * .1).kH,
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
          OtpTextField(
            autoFocus: true,
            numberOfFields: 5,
            cursorColor: AppTheme.lightAppColors.primary,
            borderColor:
                AppTheme.lightAppColors.primary, // Default border color
            focusedBorderColor:
                AppTheme.lightAppColors.primary, // Border color when focused
            showFieldAsBox: true,
            fieldWidth: context.screenWidth * 0.12, // Adjust field width
            keyboardType: TextInputType.number, // Set keyboard to number only
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onCodeChanged: (String code) {
              // Handle validation or checks here
            },
            onSubmit: (String verificationCode) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Verification Code"),
                    content: Text('Code entered is $verificationCode'),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
