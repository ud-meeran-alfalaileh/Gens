import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/login/model/login_form_model.dart';
import 'package:gens/src/feature/login/view/widgte/collection/auth_form_widget.dart';
import 'package:gens/src/feature/vendor_services/view/widget/text/services_text.dart';
import 'package:gens/src/feature/waiting_list/controller/waiting_list_controller.dart';
import 'package:gens/src/feature/waiting_list/view/widget/collection/date_range_widgte.dart';
import 'package:gens/src/feature/waiting_list/view/widget/text/waiting_list_text.dart';
import 'package:get/get.dart';

class WaitingListWidget extends StatefulWidget {
  const WaitingListWidget(
      {super.key,
      required this.dayOfTheWeek,
      required this.data,
      required this.serviceId,
      required this.vendorId});
  final int vendorId;
  final int serviceId;

  final String dayOfTheWeek;
  final String data;

  @override
  State<WaitingListWidget> createState() => _WaitingListWidgetState();
}

class _WaitingListWidgetState extends State<WaitingListWidget> {
  final controller = Get.put(WaitingListController());

  @override
  void initState() {
    super.initState();
    // controller.getWorkingHours(widget.vendorId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color:
                                AppTheme.lightAppColors.black.withOpacity(.8),
                          )),
                      const Spacer(),
                      WaitingListText.mainText("Join the Wishing List".tr),
                      const Spacer(),
                      (30.0).kW,
                    ],
                  ),
                  40.0.kH,
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const DateRangeWidget());
                    },
                    child: Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          WaitingListText.secText("Range Date".tr),
                          controller.formattedEnd.value == '' ||
                                  controller.formattedStart.value == ''
                              ? WaitingListText.thirdText("Select Date".tr)
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        WaitingListText.thirdText("From".tr),
                                        WaitingListText.thirdText(
                                            controller.formattedStart.value),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        WaitingListText.thirdText("To".tr),
                                        WaitingListText.thirdText(
                                            controller.formattedEnd.value),
                                      ],
                                    )
                                  ],
                                )
                        ],
                      ),
                    ),
                  ),
                  40.0.kH,
                  Row(
                    children: [
                      WaitingListText.secText("Select Hour".tr),
                      const Spacer(),
                      SizedBox(
                        width: context.screenWidth * .22,
                        height: context.screenHeight * .05,
                        child: AuthForm(
                          formModel: FormModel(
                            onTap: () {},
                            enableText: false,
                            controller: controller.startTime,
                            hintText: "00",
                            invisible: false,
                            validator: null,
                            type: TextInputType.phone,
                            inputFormat: [
                              MaxValueTextInputFormatter(maxValue: 23),
                              LengthLimitingTextInputFormatter(2),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                      ),
                      5.0.kW,
                      WaitingListText.thirdText('To'.tr),
                      5.0.kW,
                      SizedBox(
                        width: context.screenWidth * .22,
                        height: context.screenHeight * .05,
                        child: AuthForm(
                          formModel: FormModel(
                            onTap: () {},
                            enableText: false,
                            controller: controller.endTime,
                            hintText: "00",
                            invisible: false,
                            validator: null,
                            type: TextInputType.phone,
                            inputFormat: [
                              MaxValueTextInputFormatter(maxValue: 23),
                              LengthLimitingTextInputFormatter(2),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  40.0.kH,
                  Row(
                    children: [
                      ServicesText.secText("Message".tr),
                    ],
                  ),
                  AuthForm(
                      maxLine: 4,
                      formModel: FormModel(
                          controller: controller.description,
                          enableText: false,
                          hintText: "Message".tr,
                          invisible: false,
                          validator: null,
                          type: TextInputType.text,
                          inputFormat: [],
                          onTap: () {})),
                  60.0.kH,
                  AppButton(
                      onTap: () {
                        controller.addWaitingList(
                            widget.vendorId, widget.serviceId, context);
                      },
                      title: "Join Waiting list".tr),
                  20.0.kH,
                ],
              ),
            ),
          ),
          Obx(() => controller.isLoading.value
              ? Container(
                  width: context.screenWidth,
                  height: context.screenHeight,
                  color: AppTheme.lightAppColors.black.withOpacity(0.2),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.lightAppColors.primary,
                    ),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}

class MaxValueTextInputFormatter extends TextInputFormatter {
  final int maxValue;

  MaxValueTextInputFormatter({required this.maxValue});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    final int value = int.tryParse(newValue.text) ?? 0;

    if (value > maxValue) {
      return oldValue;
    }

    return newValue;
  }
}
