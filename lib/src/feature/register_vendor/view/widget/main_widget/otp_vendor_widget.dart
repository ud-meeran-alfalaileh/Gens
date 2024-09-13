import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/core/utils/loading_page.dart';
import 'package:gens/src/feature/forgtet_password/view/widget/text/forget_password_text.dart';
import 'package:gens/src/feature/register_vendor/controller/vendor_register_controller.dart';
import 'package:get/get.dart';

class OtpVendorWidget extends StatefulWidget {
  const OtpVendorWidget({super.key});

  @override
  State<OtpVendorWidget> createState() => _OtpWidgetState();
}

class _OtpWidgetState extends State<OtpVendorWidget> {
  final controller = Get.put(VendorRegisterController());
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    controller.remainingTime.value = 30;
    controller.isButtonEnabled.value = false;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (controller.remainingTime.value > 0) {
        controller.remainingTime.value--;
      } else {
        controller.isButtonEnabled.value = true;
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: Obx(
        () => Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  (context.screenHeight * .05).kH,
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.arrow_back_ios),
                      )
                    ],
                  ),
                  (context.screenHeight * .1).kH,
                  ForgetPasswordText.mainText(
                    'OTP Verification'.tr,
                  ),
                  10.0.kH,
                  ForgetPasswordText.secText(
                      "Enter the verification code we just send on your Email"
                          .tr),
                  (context.screenHeight * .072).kH,
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: OtpTextField(
                      autoFocus: true,
                      numberOfFields: 4,
                      cursorColor: AppTheme.lightAppColors.primary,
                      borderColor: AppTheme.lightAppColors.primary,
                      focusedBorderColor: AppTheme.lightAppColors.primary,
                      showFieldAsBox: true,
                      fieldWidth: context.screenWidth * 0.12,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onCodeChanged: (String code) {},
                      onSubmit: (String verificationCode) {
                        controller.checklOtp(verificationCode, context);
                      },
                    ),
                  ),
                  (context.screenHeight * .04).kH,
                  SizedBox(
                    width: context.screenWidth * .7,
                    child: AppButton(onTap: () {}, title: "Continue".tr),
                  ),
                  20.0.kH,
                  TextButton(
                    onPressed: () {
                      if (controller.isButtonEnabled.value) {
                        controller.sendEmail(context);
                        _startTimer();
                      } else {
                        null;
                      }
                    },
                    child: Text(
                      controller.remainingTime > 0
                          ? 'Resend OTP in ${controller.remainingTime.value} seconds'
                          : 'Resend',
                      style: TextStyle(color: AppTheme.lightAppColors.primary),
                    ),
                  ),
                  10.0.kH,
                ],
              ),
            ),
            controller.isLoading.value
                ? loadingPage(context)
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
