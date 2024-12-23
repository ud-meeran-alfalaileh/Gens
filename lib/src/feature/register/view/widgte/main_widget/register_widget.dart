import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/core/utils/loading_page.dart';
import 'package:gens/src/feature/login/model/login_form_model.dart';
import 'package:gens/src/feature/login/view/widgte/collection/auth_form_widget.dart';
import 'package:gens/src/feature/login/view/widgte/text/login_text.dart';
import 'package:gens/src/feature/register/controller/register_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

RxString errorText = "".obs;
RxString errorTextPageTwo = "".obs;

class RegisterWidget extends StatelessWidget {
  const RegisterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());
    return SafeArea(
      child: Obx(
        () => Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(Icons.arrow_back_ios_new,
                              color: AppTheme.lightAppColors.black))
                    ],
                  ),
                  Image.asset(
                    "assets/image/logo.png",
                    width: context.screenWidth * .45,
                    fit: BoxFit.cover,
                  ),
                  LoginText.mainText("Create Account".tr),
                  LoginText.secText("We are here to help you!".tr),
                  Align(
                    alignment: Alignment.center,
                    child: Obx(
                      () => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          width: context.screenWidth,
                          height: context.screenHeight * .42,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50)),
                          child: PageView(
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
                          errorText.value =
                              controller.pageOneValidateAllFields()!;

                          if (controller.currentPageIndex.value == 0) {
                            if (errorText.value == "valid") {
                              controller.nextPage();
                            }
                          } else {
                            errorTextPageTwo.value =
                                controller.validateAllFields()!;
                            if (errorTextPageTwo.value == 'valid') {
                              errorTextPageTwo.value = errorText.value =
                                  controller.pageOneValidateAllFields()!;
                              if (errorText.value == "valid") {
                                controller.checkExist(context);
                              }

                              // Get.to(() => const OtpWidget());
                              // controller.register(context);
                            }
                          }
                        },
                        title: controller.currentPageIndex.value == 0
                            ? 'next'.tr
                            : 'Register'.tr,
                      ),
                    ),
                  ),
                  (context.screenWidth * .06).kH,
                  // SizedBox(
                  //   height: context.screenHeight * .02,
                  //   child: Stack(
                  //     children: [
                  //       const Divider(),
                  //       Align(
                  //         alignment: Alignment.center,
                  //         child: Container(
                  //           width: context.screenWidth * .1,
                  //           color: AppTheme.lightAppColors.background,
                  //           child: const Center(child: Text("Or")),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // Align(
                  //     alignment: Alignment.bottomCenter,
                  //     child: Container(
                  //         height: context.screenHeight * .03,
                  //         width: context.screenWidth,
                  //         decoration: BoxDecoration(
                  //             color: AppTheme.lightAppColors.background,
                  //             borderRadius: const BorderRadius.vertical(
                  //                 top: Radius.circular(30))),
                  //         child: Center(
                  //           child: LoginText.dontHaveAccount(() {
                  //             Get.back();
                  //           }),
                  //         )))
                ],
              ),
            ),
            controller.isLoading.value
                ? loadingPage(context)
                : const SizedBox.shrink()
          ],
        ),
      ),
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
                  icon: Icons.person_outline_outlined,
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
                  icon: Icons.person_outline_outlined,
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
                  icon: Icons.phone_outlined,
                  controller: controller.phoneNumber,
                  enableText: false,
                  hintText: "000 000 0000",
                  invisible: false,
                  validator: (value) => controller.validatePhoneNumber(value!),
                  type: TextInputType.phone,
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
                  focusColor: Colors.transparent,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person_2_outlined,
                      color: AppTheme.lightAppColors.secondaryColor,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Set border radius
                      borderSide: BorderSide.none, // Remove border side
                    ),
                    filled: true, // Enable fill color
                    fillColor: AppTheme
                        .lightAppColors.maincolor, // Set your fill color
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

  Future<void> selectDate(
      BuildContext context, RegisterController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppTheme.lightAppColors.primary, // Custom color
            colorScheme:
                ColorScheme.light(primary: AppTheme.lightAppColors.primary),
          ),
          child: child!,
        );
      },
    );

    DateTime dateOnly =
        DateTime(selectedDate!.year, selectedDate.month, selectedDate.day);

    // Format the date as YYYY-MM-DD
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateOnly);

    controller.dateOfBirth.text = formattedDate;
  }

  registerPageTwo(BuildContext context, RegisterController controller) {
    RxBool showPassword = true.obs;
    RxBool showCPassword = true.obs;

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
          (17.0).kH,
          Obx(
            () => Stack(
              children: [
                AuthForm(
                  formModel: FormModel(
                      icon: Icons.lock_outline,
                      controller: controller.password,
                      enableText: false,
                      hintText: 'loginPassword'.tr,
                      invisible: showPassword.value,
                      validator: null,
                      type: TextInputType.text,
                      inputFormat: [],
                      onTap: () {}),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          showPassword.value = !showPassword.value;
                        },
                        icon: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Icon(
                            !showPassword.value
                                ? Icons.remove_red_eye_outlined
                                : Icons.remove_red_eye,
                            color: AppTheme.lightAppColors.primary,
                          ),
                        )),
                  ],
                )
              ],
            ),
          ),
          (17.0).kH,
          Obx(
            () => Stack(
              children: [
                AuthForm(
                  formModel: FormModel(
                      icon: Icons.lock_outline,
                      controller: controller.confirmPassword,
                      enableText: false,
                      hintText: "confirmPassword".tr,
                      invisible: showCPassword.value,
                      validator: null,
                      type: TextInputType.text,
                      inputFormat: [],
                      onTap: () {}),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          showCPassword.value = !showCPassword.value;
                        },
                        icon: Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Icon(
                            !showCPassword.value
                                ? Icons.remove_red_eye_outlined
                                : Icons.remove_red_eye,
                            color: AppTheme.lightAppColors.primary,
                          ),
                        )),
                  ],
                )
              ],
            ),
          ),
          (17.0).kH,
          Stack(
            children: [
              AuthForm(
                formModel: FormModel(
                    icon: Icons.calendar_month_outlined,
                    controller: controller.dateOfBirth,
                    enableText: true,
                    hintText: "Date of Birth".tr,
                    invisible: false,
                    validator: null,
                    type: TextInputType.text,
                    inputFormat: [],
                    onTap: () {}),
              ),
              GestureDetector(
                onTap: () {
                  selectDate(context, controller);
                },
                child: Container(
                  width: context.screenWidth,
                  height: context.screenHeight * .05,
                  color: Colors.transparent,
                ),
              )
            ],
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
