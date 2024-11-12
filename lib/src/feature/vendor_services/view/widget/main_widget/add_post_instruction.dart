import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/core/utils/snack_bar.dart';
import 'package:gens/src/feature/dashboard/view/widget/text/dashboard_text.dart';
import 'package:gens/src/feature/login/model/login_form_model.dart';
import 'package:gens/src/feature/login/view/widgte/collection/auth_form_widget.dart';
import 'package:gens/src/feature/vendor_services/controller/vendor_services_controller.dart';
import 'package:get/get.dart';

class AddPostInstructionWidget extends StatelessWidget {
  const AddPostInstructionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VendorServicesController());
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: Obx(
        () => controller.isLoading.value
            ? Container(
                width: context.screenWidth,
                height: context.screenHeight,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.lightAppColors.primary,
                  ),
                ),
              )
            : SafeArea(
                bottom: false,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            DashboardText.mainText(
                                "Service Post instruction".tr),
                            20.0.kH,
                            Text(
                              "How many days should these post-care instructions be followed?"
                                  .tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppTheme.lightAppColors.mainTextcolor,
                                  fontFamily: "Inter",
                                  fontSize: 17),
                            ),
                            20.0.kH,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: context.screenWidth * .25,
                                  child: AuthForm(
                                      formModel: FormModel(
                                          onChange: (val) {
                                            if (val != null && val.isNotEmpty) {
                                              try {
                                                int days = int.parse(val);
                                                controller.daysOfInstruction
                                                    .value = days;
                                                controller
                                                    .updateInstructionControllers(
                                                        days);
                                              } catch (e) {
                                                controller.daysOfInstruction
                                                    .value = 0;
                                                controller
                                                    .updateInstructionControllers(
                                                        0);
                                                showSnackBar(
                                                    "Please enter a valid number"
                                                        .tr,
                                                    "Error".tr,
                                                    Colors.red);
                                              }
                                            } else {
                                              controller
                                                  .daysOfInstruction.value = 0;
                                              controller
                                                  .updateInstructionControllers(
                                                      0);
                                            }
                                          },
                                          controller:
                                              controller.postInstructionDays,
                                          enableText: false,
                                          hintText: "Days".tr,
                                          invisible: false,
                                          validator: null,
                                          type: TextInputType.number,
                                          inputFormat: [],
                                          onTap: () {})),
                                )
                              ],
                            ),
                            60.0.kH,
                            Text(
                              "Please list any specific aftercare guidelines, such as things the patient should avoid or steps to follow during this period."
                                  .tr,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: AppTheme.lightAppColors.mainTextcolor,
                                  fontFamily: "Inter",
                                  fontSize: 17),
                            ),
                            // 30.0.kH,
                            // AuthForm(
                            //     maxLine: 4,
                            //     formModel: FormModel(
                            //         controller: controller.postInstruction,
                            //         enableText: false,
                            //         hintText: "Post Instructions",
                            //         invisible: false,
                            //         validator: null,
                            //         type: TextInputType.text,
                            //         inputFormat: [],
                            //         onTap: () {})),
                            30.0.kH,
                            Obx(
                              () => ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Day".tr,
                                              style: const TextStyle(
                                                  fontFamily: "Inter",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              " ${index + 1}",
                                              style: const TextStyle(
                                                  fontFamily: "Inter",
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        AuthForm(
                                            maxLine: 2,
                                            formModel: FormModel(
                                                controller: controller
                                                        .instructionControllers[
                                                    index],
                                                enableText: false,
                                                hintText:
                                                    "Post Instructions".tr,
                                                invisible: false,
                                                validator: null,
                                                type: TextInputType.text,
                                                inputFormat: [],
                                                onTap: () {})),
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return 20.0.kH;
                                  },
                                  itemCount:
                                      controller.daysOfInstruction.value == 0
                                          ? 0
                                          : controller.daysOfInstruction.value),
                            ),
                            AppButton(
                              onTap: () {
                                print('object');
                                if (controller
                                        .postInstructionDays.text.isEmpty ||
                                    !controller.areAllInstructionsFilled()) {
                                  showSnackBar(
                                      "Make sure all fields are filed".tr,
                                      "Error".tr,
                                      Colors.red);
                                  print('object');
                                } else {
                                  print('object');
                                  controller.addInstruction();
                                }
                              },
                              title: "Add Instruction".tr,
                            ),
                            100.0.kH,
                          ],
                        ),
                      ),
                    ),
                    controller.isLoading.value
                        ? Container(
                            width: context.screenWidth,
                            height: context.screenHeight * .93,
                            color: AppTheme.lightAppColors.bordercolor
                                .withOpacity(0.2),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.lightAppColors.primary,
                              ),
                            ),
                          )
                        : const SizedBox.shrink()
                  ],
                ),
              ),
      ),
    );
  }
}
