import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/login/model/login_form_model.dart';
import 'package:gens/src/feature/login/view/widgte/collection/auth_form_widget.dart';
import 'package:gens/src/feature/login/view/widgte/text/login_text.dart';
import 'package:gens/src/feature/register/controller/register_controller.dart';
import 'package:get/get.dart';

RxString errorText = "".obs;
RxString errorTextPageTwo = "".obs;

class RegisterWidget extends StatelessWidget {
  const RegisterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());
    return Column(
      children: [
        (context.screenHeight * .07).kH,
        Image.asset(
          "assets/image/logo.png",
          width: context.screenWidth * .6,
          fit: BoxFit.cover,
        ),
        LoginText.mainText("Create Account"),
        10.0.kH,
        LoginText.secText("We are here to help you!"),
        Align(
          alignment: Alignment.center,
          child: Obx(
            () => Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: context.screenWidth,
                height: context.screenHeight * .42,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(50)),
                child: PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller.pageController,
                  onPageChanged: (index) {
                    controller.currentPageIndex.value = index;
                  },
                  children: [
                    registerPageOne(context, controller),
                    registerPageTwo(context, controller),
                  ],
                )),
          ),
        ),
        Obx(
          () => SizedBox(
            width: context.screenWidth * .85,
            child: AppButton(
              onTap: () {
                errorText.value = controller.pageOneValidateAllFields()!;
                errorTextPageTwo.value = controller.validateAllFields()!;
                if (controller.currentPageIndex.value == 0) {
                  if (errorText.value == "valid") {
                    controller.nextPage();
                  } else if (errorTextPageTwo.value == 'valid') {
                    controller.register(context);
                  }
                }
              },
              title: controller.currentPageIndex.value == 0
                  ? 'next'.tr
                  : 'register'.tr,
            ),
          ),
        ),
        (context.screenWidth * .06).kH,
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
                height: context.screenHeight * .03,
                width: context.screenWidth,
                decoration: BoxDecoration(
                    color: AppTheme.lightAppColors.background,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(30))),
                child: Center(
                  child: LoginText.haveAccount(() {
                    Get.back();
                  }),
                )))
      ],
    );
  }

  registerPageOne(BuildContext context, RegisterController controller) {
    return SingleChildScrollView(
      child: IntrinsicHeight(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Display validation errors at the top of the form
              Obx(() {
                return errorText.value != "" && errorText.value != "valid"
                    ? Column(
                        children: [
                          (context.screenHeight * .03).kH,
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              children: [
                                Text(
                                  errorText.value,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 14.0),
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : (context.screenHeight * .04).kH;
              }),

              AuthForm(
                formModel: FormModel(
                  icon: Icons.person,
                  controller: controller.name,
                  enableText: false,
                  hintText: 'loginName'.tr,
                  invisible: false,
                  validator: null,
                  type: TextInputType.text,
                  inputFormat: [],
                  onTap: () {},
                ),
              ),
              (15.5).kH,
              AuthForm(
                formModel: FormModel(
                  icon: Icons.person,
                  controller: controller.secName,
                  enableText: false,
                  hintText: 'loginSecName'.tr,
                  invisible: false,
                  validator: null,
                  type: TextInputType.text,
                  inputFormat: [],
                  onTap: () {},
                ),
              ),
              (15.5).kH,
              AuthForm(
                formModel: FormModel(
                  icon: Icons.phone,
                  controller: controller.phoneNumber,
                  enableText: false,
                  hintText: "000 000 0000",
                  invisible: false,
                  validator: (value) => controller.validatePhoneNumber(value!),
                  type: TextInputType.text,
                  inputFormat: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onTap: () {},
                ),
              ),
              (15.5).kH,
              Center(
                child: DropdownButtonFormField<String>(
                  value: controller.selectedGender.value,
                  hint: Text('Select a Gender'.tr),
                  items: controller.genderOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    controller.selectedGender.value = newValue!;
                  },
                  iconEnabledColor: AppTheme.lightAppColors.primary,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                  ),
                  focusColor: Colors.black,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.flag,
                        color: AppTheme.lightAppColors.primary),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppTheme.lightAppColors.primary,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppTheme.lightAppColors.primary,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: AppTheme.lightAppColors.primary,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                  dropdownColor: Colors.white,
                ),
              ),
              (25.5).kH,

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  registerPageTwo(BuildContext context, RegisterController controller) {
    return Form(
      key: controller.fromKeyTwo,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() {
            return errorTextPageTwo.value != "" &&
                    errorTextPageTwo.value != "valid"
                ? Column(
                    children: [
                      (context.screenHeight * .02).kH,
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          children: [
                            Text(
                              errorTextPageTwo.value,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14.0),
                              textAlign: TextAlign.start,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : (context.screenHeight * .04)
                    .kH; // If no errors, display nothing
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
          (20.5).kH,
          AuthForm(
            formModel: FormModel(
                icon: Icons.lock_outline,
                controller: controller.password,
                enableText: false,
                hintText: "loginPassword".tr,
                invisible: true,
                validator: null,
                type: TextInputType.text,
                inputFormat: [],
                onTap: () {}),
          ),
          (20.5).kH,
          AuthForm(
            formModel: FormModel(
                icon: Icons.lock_outline,
                controller: controller.confirmPassword,
                enableText: false,
                hintText: "confirmPassword".tr,
                invisible: true,
                validator: null,
                type: TextInputType.text,
                inputFormat: [],
                onTap: () {}),
          ),
          const Spacer(),
          // SizedBox(
          //   width: context.screenWidth * .25,
          //   child: AppButton(
          //     onTap: () {
          //       errorTextPageTwo.value = controller.validateAllFields()!;
          //     },
          //     title: 'start'.tr,
          //   ),
          // ),
        ],
      ),
    );
  }
}
