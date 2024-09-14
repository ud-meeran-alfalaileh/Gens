import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/login/model/login_form_model.dart';
import 'package:gens/src/feature/login/view/widgte/collection/auth_form_widget.dart';
import 'package:gens/src/feature/profile/view/widget/text/profile_text.dart';
import 'package:gens/src/feature/register_vendor/view/widget/text/vendor_register_text.dart';
import 'package:gens/src/feature/vendor_profile/controller/vendor_profile_controller.dart';
import 'package:get/get.dart';

class VendorUpdateProfile extends StatelessWidget {
  const VendorUpdateProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VendorProfileController());
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: AppTheme.lightAppColors.primary,
                        )),
                    SizedBox(
                      width: context.screenWidth * .67,
                      child: Center(
                        child: ProfileText.mainText("Update your details"),
                      ),
                    ),
                  ],
                ),
                20.0.kH,
                Container(
                  width: context.screenWidth,
                  height: context.screenHeight * .2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(controller.image.text),
                      )),
                ),
                20.0.kH,
                VendorRegisterText.mainText("Name"),
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
                VendorRegisterText.mainText("Address"),
                AuthForm(
                  formModel: FormModel(
                      icon: Icons.location_on_outlined,
                      controller: controller.location,
                      enableText: false,
                      hintText: 'Address'.tr,
                      invisible: false,
                      validator: null,
                      type: TextInputType.text,
                      inputFormat: [],
                      onTap: () {}),
                ),
                20.0.kH,
                VendorRegisterText.mainText("Description"),
                AuthForm(
                  formModel: FormModel(
                      icon: Icons.text_fields,
                      controller: controller.description,
                      enableText: false,
                      hintText: "Description".tr,
                      invisible: false,
                      validator: null,
                      type: TextInputType.text,
                      inputFormat: [],
                      onTap: () {}),
                ),
                20.0.kH,
                // VendorRegisterText.mainText("Phone Number"),
                // AuthForm(
                //   formModel: FormModel(
                //     icon: Icons.phone,
                //     controller: controller.phone,
                //     enableText: false,
                //     hintText: 'phone'.tr,
                //     invisible: false,
                //     validator: null,
                //     type: TextInputType.text,
                //     inputFormat: [
                //       LengthLimitingTextInputFormatter(10),
                //       FilteringTextInputFormatter.digitsOnly,
                //     ],
                //     onTap: () {},
                //   ),
                // ),
                // 20.0.kH,
                VendorRegisterText.mainText("Specialty"),
                AuthForm(
                  formModel: FormModel(
                      icon: Icons.add_business_outlined,
                      controller: controller.userType,
                      enableText: false,
                      hintText: "Specialty".tr,
                      invisible: false,
                      validator: null,
                      type: TextInputType.text,
                      inputFormat: [],
                      onTap: () {}),
                ),
                20.0.kH,
                Center(
                  child: SizedBox(
                      width: context.screenWidth * .7,
                      child: AppButton(onTap: () {}, title: "Update")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
