import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/login/model/login_form_model.dart';
import 'package:gens/src/feature/login/view/widgte/collection/auth_form_widget.dart';
import 'package:gens/src/feature/register_vendor/controller/vendor_register_controller.dart';
import 'package:gens/src/feature/register_vendor/model/schaduale_model.dart';
import 'package:gens/src/feature/register_vendor/view/widget/text/vendor_register_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RegisterPageFour extends StatelessWidget {
  const RegisterPageFour({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VendorRegisterController());
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: Obx(
        () => controller.isUpdating.value
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    VendorRegisterText.thirdText(
                        "It will take a few second".tr),
                    50.0.kH,
                    SpinKitCubeGrid(
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: index.isEven
                                ? AppTheme.lightAppColors.primary
                                : AppTheme.lightAppColors.maincolor,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              )
            : Container(
                padding: const EdgeInsets.all(20),
                color: AppTheme.lightAppColors.background.withOpacity(0.8),
                height: context.screenHeight,
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          20.0.kH,
                          VendorRegisterText.secText('FouthPageHeader'.tr),
                          70.0.kH,
                          VendorRegisterText.mainText("Select working days".tr),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * .4,
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller.allDays.length,
                              itemBuilder: (context, index) {
                                String day = controller.allDays[index];

                                return Obx(
                                  () {
                                    bool isSelected =
                                        controller.selectedDays.contains(day);
                                    return GestureDetector(
                                      onTap: () =>
                                          controller.toggleDaySelection(day),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: isSelected
                                              ? AppTheme.lightAppColors.primary
                                              : AppTheme
                                                  .lightAppColors.maincolor,
                                          border: Border.all(
                                            color: isSelected
                                                ? AppTheme
                                                    .lightAppColors.background
                                                : AppTheme
                                                    .lightAppColors.primary,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            Get.locale!.languageCode == "en"
                                                ? controller.allDays[index]
                                                : controller
                                                    .daysTranslations[day]!,
                                            style: TextStyle(
                                              color: isSelected
                                                  ? AppTheme
                                                      .lightAppColors.background
                                                  : AppTheme
                                                      .lightAppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 20,
                                crossAxisCount: 3,
                                childAspectRatio: 1.5,
                              ),
                            ),
                          ),
                          VendorRegisterText.mainText(
                              "Select working Hours".tr),
                          Row(
                            children: [
                              VendorRegisterText.mainText("From".tr),
                              Expanded(
                                child: Stack(
                                  children: [
                                    AuthForm(
                                      formModel: FormModel(
                                        onTap: () {},
                                        enableText: true,
                                        controller: controller.operHour,
                                        hintText: "00:00",
                                        invisible: false,
                                        validator: null,
                                        type: TextInputType.datetime,
                                        inputFormat: [],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        controller.workingTime(
                                            context, controller.operHour);
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .3,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .06,
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              VendorRegisterText.mainText("To1".tr),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Stack(
                                  children: [
                                    AuthForm(
                                      formModel: FormModel(
                                        enableText: false,
                                        controller: controller.closeHour,
                                        hintText: "00:00",
                                        invisible: false,
                                        validator: null,
                                        type: TextInputType.datetime,
                                        inputFormat: [],
                                        onTap: () {
                                          controller.workingTime(
                                              context, controller.closeHour);
                                        },
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        controller.workingTime(
                                            context, controller.closeHour);
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .4,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .06,
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              20.0.kW,
                            ],
                          ),
                          20.0.kH,
                          Center(
                            child: SizedBox(
                              width: context.screenWidth * .5,
                              child: AppButton(
                                onTap: () async {
                                  // Step 1: Check if any day is selected
                                  if (controller.selectedDays.isEmpty) {
                                    Get.snackbar(
                                        "Error".tr,
                                        "Please select at least one working day."
                                            .tr);
                                    return;
                                  }

                                  // Step 2: Validate that open and close hours are not empty
                                  if (controller.operHour.text.isEmpty ||
                                      controller.closeHour.text.isEmpty) {
                                    Get.snackbar(
                                        "Error".tr,
                                        "Please select both opening and closing hours."
                                            .tr);
                                    return;
                                  }

                                  // Step 3: Ensure that open hours are less than close hours
                                  try {
                                    DateTime openTime = DateFormat('HH:mm')
                                        .parse(controller.operHour.text);
                                    DateTime closeTime = DateFormat('HH:mm')
                                        .parse(controller.closeHour.text);

                                    if (openTime.isAfter(closeTime)) {
                                      Get.snackbar(
                                          "Error".tr,
                                          "Opening hours must be earlier than closing hours."
                                              .tr);
                                      return;
                                    }
                                  } catch (e) {
                                    Get.snackbar("Error",
                                        "Invalid time format. Please re-enter the times.");
                                    return;
                                  }

                                  // Clear schedules before adding
                                  controller.schedules.clear();

                                  for (String day in controller.allDays) {
                                    print(day);
                                    String openTime =
                                        controller.selectedDays.contains(day)
                                            ? DateFormat('HH:mm:ss').format(
                                                DateFormat('HH:mm').parse(
                                                    controller.operHour.text))
                                            : "00:00:00";
                                    String closeTime =
                                        controller.selectedDays.contains(day)
                                            ? DateFormat('HH:mm:ss').format(
                                                DateFormat('HH:mm').parse(
                                                    controller.closeHour.text))
                                            : "00:00:00";

                                    User user = User();
                                    await user.loadVendorId();

                                    controller.schedules.add(
                                      Schedule(
                                        id: 0, // Set as needed
                                        vendorId: user
                                            .vendorId.value, // Set as needed
                                        day: day,
                                        status: controller.selectedDays
                                            .contains(day),
                                        openTime: openTime,
                                        closeTime: closeTime,
                                      ),
                                    );
                                  }

                                  // Convert list of Schedule objects to JSON
                                  controller.jsonString.value = jsonEncode(
                                      controller.schedules
                                          .map((schedule) => schedule.toJson())
                                          .toList());

                                  controller.postSchedule();
                                },
                                title: 'Continue'.tr,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
