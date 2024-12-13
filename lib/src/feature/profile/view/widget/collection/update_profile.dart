import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/forgtet_password/view/widget/text/forget_password_text.dart';
import 'package:gens/src/feature/login/model/login_form_model.dart';
import 'package:gens/src/feature/login/view/widgte/collection/auth_form_widget.dart';
import 'package:gens/src/feature/profile/controller/profile_controller.dart';
import 'package:get/get.dart';

class UpdateProfile extends StatelessWidget {
  const UpdateProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SafeArea(
          child: Column(
            children: [
              20.0.kH,
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.arrow_back_ios_new))
                ],
              ),
              30.0.kH,
              ForgetPasswordText.mainText("You Can Update Your \nData Here".tr),
              40.0.kH,
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
                  validator: null,
                  type: TextInputType.phone,
                  inputFormat: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onTap: () {},
                ),
              ),
              (15.5).kH,
              // Center(
              //   child: DropdownButtonFormField<String>(
              //     value: controller.selectedGender.value,
              //     hint: Text('Select a Gender'.tr),
              //     items: controller.genderOptions.map((String value) {
              //       return DropdownMenuItem<String>(
              //         value: value,
              //         child: Text(
              //           value,
              //           style: const TextStyle(
              //             fontFamily: "Inter",
              //             fontWeight: FontWeight.w400,
              //             color: Colors.black,
              //             fontSize: 14,
              //           ),
              //         ),
              //       );
              //     }).toList(),
              //     onChanged: (newValue) {
              //       controller.selectedGender.value = newValue!;
              //     },
              //     iconEnabledColor: AppTheme.lightAppColors.primary,
              //     icon: const Icon(
              //       Icons.arrow_drop_down,
              //     ),
              //     focusColor: Colors.black,
              //     decoration: InputDecoration(
              //       prefixIcon: Icon(Icons.person_2_outlined,
              //           color: AppTheme.lightAppColors.primary),
              //       border: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: AppTheme.lightAppColors.primary,
              //         ),
              //         borderRadius: BorderRadius.circular(5.0),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: AppTheme.lightAppColors.primary,
              //           width: 1.0,
              //         ),
              //         borderRadius: BorderRadius.circular(5.0),
              //       ),
              //       enabledBorder: OutlineInputBorder(
              //         borderSide: BorderSide(
              //           color: AppTheme.lightAppColors.primary,
              //         ),
              //         borderRadius: BorderRadius.circular(5.0),
              //       ),
              //     ),
              //     style: const TextStyle(
              //       fontSize: 16.0,
              //       color: Colors.black,
              //     ),
              //     dropdownColor: Colors.white,
              //   ),
              // ),
              // 10.0.kH,
              AppButton(
                  onTap: () {
                    controller.updateUser(context);
                  },
                  title: "Update")
            ],
          ),
        ),
      ),
    );
  }
}
