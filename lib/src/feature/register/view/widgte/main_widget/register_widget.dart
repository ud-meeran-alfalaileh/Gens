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
import 'package:gens/src/feature/register/model/country_model.dart';
import 'package:get/get.dart';

class RegisterWidget extends StatelessWidget {
  const RegisterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterController());
    return Stack(
      children: [
        Container(
          width: context.screenWidth,
          height: context.screenHeight,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("assets/icon/ChatBG2.jpg"),
              fit: BoxFit.fitWidth,
              repeat: ImageRepeat.repeat,
              opacity: .7,
              colorFilter: ColorFilter.mode(
                AppTheme.lightAppColors.background.withOpacity(0.5),
                BlendMode.lighten,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Obx(
            () => Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.all(24),
                width: context.screenWidth,
                height: controller.currentPageIndex.value == 0
                    ? context.screenHeight * .65
                    : context.screenHeight * .55,
                decoration: BoxDecoration(
                    color: AppTheme.lightAppColors.background,
                    borderRadius: BorderRadius.circular(20)),
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
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                height: context.screenHeight * .08,
                width: context.screenWidth,
                decoration: BoxDecoration(
                    color: AppTheme.lightAppColors.background,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(30))),
                child: Center(child: LoginText.dontHaveAccount(() {
                  Get.back();
                }))))
      ],
    );
  }

  registerPageOne(BuildContext context, RegisterController controller) {
    RxString errorText = "".obs;

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: context.screenHeight * .5,
        ),
        child: IntrinsicHeight(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/icon/Logo.png",
                  width: context.screenWidth * .4,
                ),

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
                Obx(() {
                  return errorText.value == "" || errorText.value == "valid"
                      ? (30.5).kH
                      : const SizedBox.shrink();
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
                    icon: Icons.phone,
                    controller: controller.phoneNumber,
                    enableText: false,
                    hintText: "000 000 0000",
                    invisible: false,
                    validator: (value) =>
                        controller.validatePhoneNumber(value!),
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
                    iconEnabledColor:
                        AppTheme.lightAppColors.primary.withOpacity(.6),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                    ),
                    focusColor: Colors.black,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: AppTheme.lightAppColors.primary.withOpacity(.6),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(.1),
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(.2),
                        ),
                        borderRadius: BorderRadius.circular(8.0),
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

                Obx(() {
                  return DropdownButtonFormField<CountryModel>(
                    value: controller.selectedCountry.value,
                    hint: Text('Select a Country'.tr),
                    items: controller.countries.map((CountryModel country) {
                      return DropdownMenuItem<CountryModel>(
                        value: country,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 10,
                              backgroundImage:
                                  NetworkImage(country.pictureOriginal),
                            ),
                            10.0.kW,
                            Text(
                              country.nameEn,
                              style: const TextStyle(
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (CountryModel? newValue) {
                      controller.selectedCountry.value = newValue;
                    },
                    iconEnabledColor:
                        AppTheme.lightAppColors.primary.withOpacity(.6),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                    ),
                    focusColor: Colors.black,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(.1),
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(.2),
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                    dropdownColor: Colors.white,
                  );
                }),
                const Spacer(),
                SizedBox(
                  width: context.screenWidth * .25,
                  child: AppButton(
                    onTap: () {
                      errorText.value = controller.pageOneValidateAllFields()!;

                      if (errorText.value == "valid") {
                        controller.nextPage();
                      }
                    },
                    title: 'start'.tr,
                  ),
                ),
              ],
            ),
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
          Image.asset(
            "assets/icon/Logo.png",
            width: context.screenWidth * .4,
          ),
          Obx(() {
            return controller.errorText.value != ""
                ? Column(
                    children: [
                      (context.screenHeight * .02).kH,
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
                : (context.screenHeight * .08)
                    .kH; // If no errors, display nothing
          }),
          AuthForm(
            formModel: FormModel(
                icon: Icons.email,
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
                icon: Icons.lock,
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
                icon: Icons.lock,
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
          SizedBox(
            width: context.screenWidth * .25,
            child: AppButton(
              onTap: () {
                controller.errorText.value = controller.validateAllFields()!;

                if (controller.errorText.value == "valid") {
                  controller.register(context);
                }
              },
              title: 'start'.tr,
            ),
          ),
        ],
      ),
    );
  }
}
