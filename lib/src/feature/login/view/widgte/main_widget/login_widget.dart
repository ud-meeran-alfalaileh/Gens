import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/forgtet_password/view/page/forget_password_page.dart';
import 'package:gens/src/feature/login/controller/login_controller.dart';
import 'package:gens/src/feature/login/model/login_form_model.dart';
import 'package:gens/src/feature/login/view/widgte/collection/auth_form_widget.dart';
import 'package:gens/src/feature/login/view/widgte/text/login_text.dart';
import 'package:gens/src/feature/register/view/pages/register_page.dart';
import 'package:get/get.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final controller = Get.put(LoginController());

  RxString errorText = "valid".obs;
  String? validateAllFields() {
    RxList<String?> errors = <String>[].obs;

    // Validate each form field and collect errors
    final emailError = controller.vaildEmail(controller.username.text);
    final passwordError = controller.vaildPassword(controller.password.text);

    if (emailError != null) errors.add("- $emailError");
    if (passwordError != null) errors.add("- $passwordError");

    if (errors.isNotEmpty) {
      return errors.first;
    }
    return "valid";
  }

  final fromKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: context.screenWidth,
        decoration: BoxDecoration(
            color: AppTheme.lightAppColors.background,
            borderRadius: BorderRadius.circular(20)),
        child: Form(
          key: fromKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                (context.screenHeight * .1).kH,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/image/logo.png",
                        width: context.screenWidth * .6,
                        fit: BoxFit.cover,
                      ),
                      LoginText.mainText("Hi, Welcome Back! "),
                      10.0.kH,
                      LoginText.secText("Hope you’re doing fine."),
                      Obx(() {
                        return errorText.value != "valid"
                            ? Column(
                                children: [
                                  (10.5).kH,
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 10.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          errorText.value,
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 14.0),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : (40.5).kH; // If no errors, display nothing
                      }),
                      AuthForm(
                        formModel: FormModel(
                            icon: Icons.email_outlined,
                            controller: controller.username,
                            enableText: false,
                            hintText: 'loginEmail'.tr,
                            invisible: false,
                            validator: null,
                            type: TextInputType.text,
                            inputFormat: [],
                            onTap: () {}),
                      ),
                      (20.5).kH,
                      AuthForm(
                        formModel: FormModel(
                            icon: Icons.lock_outline,
                            controller: controller.password,
                            enableText: false,
                            hintText: 'loginPassword'.tr,
                            invisible: true,
                            validator: null,
                            type: TextInputType.text,
                            inputFormat: [],
                            onTap: () {}),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(() => ForgetPasswordPage());
                            },
                            child: const Text("Forgot password?"),
                          ),
                        ],
                      ),
                      (20.5).kH,
                      SizedBox(
                        width: context.screenWidth * .4,
                        child: AppButton(
                          onTap: () {
                            errorText.value = validateAllFields()!;
                            if (errorText.value == "valid") {
                              controller.login(context);
                            }
                          },
                          title: 'login'.tr,
                        ),
                      ),
                      30.0.kH,
                    ],
                  ),
                ),
                (context.screenWidth * .1).kH,
                SizedBox(
                  height: context.screenHeight * .02,
                  child: Stack(
                    children: [
                      const Divider(),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: context.screenWidth * .1,
                          color: AppTheme.lightAppColors.background,
                          child: const Center(child: Text("Or")),
                        ),
                      )
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                        height: context.screenHeight * .08,
                        width: context.screenWidth,
                        decoration: BoxDecoration(
                            color: AppTheme.lightAppColors.background,
                            borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(30))),
                        child: Center(
                          child: LoginText.haveAccount(() {
                            Get.to(() => const RegisterPage());
                          }),
                        )))
              ],
            ),
          ),
        ));
  }
}
