import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/core/utils/loading_page.dart';
import 'package:gens/src/feature/login/model/login_form_model.dart';
import 'package:gens/src/feature/login/view/widgte/collection/auth_form_widget.dart';
import 'package:gens/src/feature/register/view/widgte/main_widget/register_widget.dart';
import 'package:gens/src/feature/register_vendor/controller/vendor_register_controller.dart';
import 'package:gens/src/feature/register_vendor/view/widget/text/vendor_register_text.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class VendorRegisterWidget extends StatelessWidget {
  const VendorRegisterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VendorRegisterController());
    return Stack(
      children: [
        Column(
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
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            height: 80,
                            width: context.screenWidth * .9,
                            decoration: const BoxDecoration(),
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Obx(() => registerCircle(
                                      context, controller, index));
                                },
                                separatorBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 39.0),
                                    child: Container(
                                      width: 100.0,
                                      height: 1,
                                      color: AppTheme.lightAppColors.maincolor,
                                    ),
                                  );
                                },
                                itemCount: 3)),
                      ),
                      Text(
                        "Enter your basic information to create your account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightAppColors.primary),
                      ),
                      Obx(() {
                        return errorText.value != "" &&
                                errorText.value != "valid"
                            ? Column(
                                children: [
                                  (context.screenHeight * .03).kH,
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
                            : (context.screenHeight * .03).kH;
                      }),
                      Container(
                          // padding: const EdgeInsets.symmetric(horizontal: 20),
                          width: context.screenWidth,
                          height: context.screenHeight * .58,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50)),
                          child: PageView(
                            // physics: const NeverScrollableScrollPhysics(),
                            controller: controller.pageController,
                            onPageChanged: (index) {
                              controller.currentPageIndex.value = index;
                            },
                            children: [
                              registerPageOne(context, controller),
                              registerPageTwo(context, controller),
                              registerPageThird(context, controller),
                              // registerPagefour(context, controller),
                            ],
                          )),
                      SizedBox(
                        width: context.screenWidth * .8,
                        child: AppButton(
                            onTap: () {
                              // if (controller.currentPageIndex.value == 2) {
                              //   // controller.vendorRegister();
                              // }
                              errorText.value =
                                  controller.pageOneValidateAllFields()!;

                              if (controller.currentPageIndex.value == 0) {
                                if (errorText.value == "valid") {
                                  errorText.value = "";
                                  controller.nextPage();
                                }
                              } else if (controller.currentPageIndex.value ==
                                  1) {
                                errorText.value =
                                    controller.pageTowValidateAllFields()!;
                                if (errorText.value == "valid") {
                                  errorText.value = "";
                                  controller.nextPage();
                                }
                              } else if (controller.currentPageIndex.value ==
                                  2) {
                                errorText.value =
                                    controller.pageThreeValidateAllFields()!;
                                if (errorText.value == "valid") {
                                  errorText.value = "";
                                  // Get.to(() => const OtpWidget());
                                  controller.sendEmail(context);
                                }
                              }
                            },
                            title: "Register"),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
        Obx(() => controller.isUpdating.value
            ? loadingPage(context)
            : const SizedBox.shrink())
      ],
    );
  }

  Container registerCircle(
      BuildContext context, VendorRegisterController controller, int index) {
    bool isCompleted = index <= controller.currentPageIndex.value;

    return Container(
      width: context.screenWidth * 0.13,
      height: context.screenHeight,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isCompleted
              ? AppTheme.lightAppColors.primary
              : AppTheme.lightAppColors.maincolor,
        ),
        color: isCompleted
            ? AppTheme.lightAppColors.maincolor
            : AppTheme.lightAppColors.background,
      ),
      child: Center(
        child: Text(
          (index + 1).toString(),
          style: TextStyle(
            fontFamily: "Inter",
            fontSize: 15,
            color: isCompleted
                ? AppTheme.lightAppColors.primary
                : AppTheme.lightAppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  registerPageOne(BuildContext context, VendorRegisterController controller) {
    return SingleChildScrollView(
      child: IntrinsicHeight(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display validation errors at the top of the form

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
              VendorRegisterText.mainText("Email"),

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
              VendorRegisterText.mainText("Password"),

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
              VendorRegisterText.mainText("Confirm Password"),

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

              (25.5).kH,

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  registerPageThird(BuildContext context, VendorRegisterController controller) {
    return SingleChildScrollView(
      child: IntrinsicHeight(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VendorRegisterText.mainText("Phone Number"),
              AuthForm(
                formModel: FormModel(
                  icon: Icons.phone,
                  controller: controller.phone,
                  enableText: false,
                  hintText: 'phone'.tr,
                  invisible: false,
                  validator: null,
                  type: TextInputType.text,
                  inputFormat: [
                    LengthLimitingTextInputFormatter(10),
                    FilteringTextInputFormatter.digitsOnly,
                  ],
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
              (20.5).kH,
              VendorRegisterText.mainText("Business License"),
              Stack(
                children: [
                  AuthForm(
                    formModel: FormModel(
                        icon: Icons.file_upload,
                        controller: controller.businessLicense,
                        enableText: true,
                        hintText: "Business License".tr,
                        invisible: false,
                        validator: null,
                        type: TextInputType.text,
                        inputFormat: [],
                        onTap: () {}),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.pickLicenseImages(context);
                    },
                    child: Container(
                      width: context.screenWidth,
                      height: context.screenHeight * .1,
                      color: Colors.transparent,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  registerPageTwo(BuildContext context, VendorRegisterController controller) {
    return SingleChildScrollView(
      child: IntrinsicHeight(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display validation errors at the top of the form

              VendorRegisterText.mainText("Pick Three Profile Images"),

              GestureDetector(
                onTap: () {
                  controller.pickImages(context);
                },
                child: Center(
                  child: Obx(
                    () => Container(
                        padding: const EdgeInsets.all(10),
                        width: context.screenWidth * .9,
                        height: controller.imageFiles!.isEmpty
                            ? context.screenHeight * .2
                            : context.screenHeight * .15,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: AppTheme.lightAppColors.primary)),
                        child: controller.imageFiles!.isEmpty
                            ? Center(
                                child: Icon(
                                  Icons.upload_file_outlined,
                                  size: 50,
                                  color: AppTheme.lightAppColors.primary,
                                ),
                              )
                            : ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "- Image ${index + 1}",
                                            style: TextStyle(
                                                color: AppTheme
                                                    .lightAppColors.black,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return 10.0.kH;
                                },
                                itemCount: controller.imageFiles!.length,
                              )),
                  ),
                ),
              ),

              (20.5).kH,
              VendorRegisterText.mainText("Description"),

              AuthForm(
                formModel: FormModel(
                    icon: Icons.text_fields,
                    controller: controller.description,
                    enableText: false,
                    hintText: "Description".tr,
                    invisible: F,
                    validator: null,
                    type: TextInputType.text,
                    inputFormat: [],
                    onTap: () {}),
              ),
              (20.5).kH,
              VendorRegisterText.mainText("Specialty"),

              AuthForm(
                formModel: FormModel(
                    icon: Icons.add_business_outlined,
                    controller: controller.userType,
                    enableText: false,
                    hintText: "Specialty".tr,
                    invisible: F,
                    validator: null,
                    type: TextInputType.text,
                    inputFormat: [],
                    onTap: () {}),
              ),
              (20.5).kH,

              (25.5).kH,

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}