import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/forgtet_password/view/widget/text/forget_password_text.dart';
import 'package:get/get.dart';

class OtpWidget extends StatelessWidget {
  const OtpWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordText());
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          // textDirection: TextDirection.rtl,
          // mainAxisAlignment: MainAxisAlignment.center,
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
              'OTP Verification'.tr,
            ),
            10.0.kH,
            ForgetPasswordText.secText(
                "Enter the verification code we just send on your Email".tr),
            (context.screenHeight * .072).kH,
            Directionality(
              textDirection: TextDirection.ltr,
              child: OtpTextField(
                autoFocus: true,
                numberOfFields: 5,
                cursorColor: AppTheme.lightAppColors.primary,
                borderColor: AppTheme.lightAppColors.primary,
                focusedBorderColor: AppTheme
                    .lightAppColors.primary, // Border color when focused
                showFieldAsBox: true,
                fieldWidth: context.screenWidth * 0.12, // Adjust field width
                keyboardType:
                    TextInputType.number, // Set keyboard to number only
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onCodeChanged: (String code) {
                  // Handle code change
                },
                onSubmit: (String verificationCode) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Verification Code"),
                        content: Text('Code entered is $verificationCode'),
                      );
                    },
                  );
                },
              ),
            ),
            (context.screenHeight * .04).kH,
            SizedBox(
                width: context.screenWidth * .7,
                child: AppButton(onTap: () {}, title: "Change Password".tr))
          ],
        ),
      ),
    );
  }
}
