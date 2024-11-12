import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/core/utils/snack_bar.dart';
import 'package:gens/src/feature/doctor_profile/model/service_model.dart';
import 'package:gens/src/feature/login/model/login_form_model.dart';
import 'package:gens/src/feature/login/view/widgte/collection/auth_form_widget.dart';
import 'package:gens/src/feature/vendor_services/controller/vendor_services_controller.dart';
import 'package:gens/src/feature/vendor_services/model/pre_service_model.dart';
import 'package:gens/src/feature/vendor_services/view/widget/main_widget/add_post_instruction.dart';
import 'package:gens/src/feature/vendor_services/view/widget/text/services_text.dart';
import 'package:get/get.dart';

class AddServiceWidget extends StatefulWidget {
  const AddServiceWidget({super.key, this.serviceId, required this.type});
  final Services? serviceId;
  final String type;

  @override
  State<AddServiceWidget> createState() => _AddServiceWidgetState();
}

class _AddServiceWidgetState extends State<AddServiceWidget> {
  final controller = Get.put(VendorServicesController());
  @override
  void initState() {
    // print(widget.serviceId!);

    widget.type == 'edit' ? controller.setServiceData(widget.serviceId!) : null;
    widget.type == 'edit'
        ? controller.getPreInstruction(widget.serviceId!.serviceId)
        : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: Obx(
        () => Stack(
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                controller.clearServiceData();
                                Get.back();
                              },
                              icon: const Icon(Icons.arrow_back_ios_new))
                        ],
                      ),
                      Center(
                        child: ServicesText.addMainText("Add service".tr),
                      ),
                      20.0.kH,
                      Row(
                        children: [
                          10.0.kW,
                          GestureDetector(
                            onTap: () {
                              controller.pickImages(context);
                            },
                            child: Container(
                                width: context.screenWidth * .3,
                                height: context.screenHeight * .14,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppTheme.lightAppColors.primary),
                                    borderRadius: BorderRadius.circular(10)),
                                child: controller.serviceImage.value != ""
                                    ? Image.network(
                                        controller.serviceImage.value,
                                      )
                                    : Image.asset("assets/image/addIamge.png")),
                          ),
                          18.0.kW,
                          SizedBox(
                            width: context.screenWidth * .5,
                            child: ServicesText.secText(
                                "pick image that will represend the service you will provide"
                                    .tr),
                          ),
                        ],
                      ),
                      20.0.kH,
                      ServicesText.secText("Service Name".tr),
                      AuthForm(
                          formModel: FormModel(
                              controller: controller.title,
                              enableText: false,
                              hintText: "Service Name".tr,
                              invisible: false,
                              validator: null,
                              type: TextInputType.text,
                              inputFormat: [],
                              onTap: () {})),
                      20.0.kH,
                      ServicesText.secText("Description".tr),
                      AuthForm(
                          maxLine: 4,
                          formModel: FormModel(
                              controller: controller.description,
                              enableText: false,
                              hintText: "Description".tr,
                              invisible: false,
                              validator: null,
                              type: TextInputType.text,
                              inputFormat: [],
                              onTap: () {})),
                      20.0.kH,
                      ServicesText.secText("Advice".tr),
                      AuthForm(
                          maxLine: 4,
                          formModel: FormModel(
                              controller: controller.advice,
                              enableText: false,
                              hintText: "Advice".tr,
                              invisible: false,
                              validator: null,
                              type: TextInputType.text,
                              inputFormat: [],
                              onTap: () {})),
                      20.0.kH,
                      ServicesText.secText("Price".tr),
                      AuthForm(
                          formModel: FormModel(
                              controller: controller.price,
                              enableText: false,
                              hintText: "Price".tr,
                              invisible: false,
                              validator: null,
                              type: TextInputType.number,
                              inputFormat: [],
                              onTap: () {})),
                      20.0.kH,
                      widget.type == 'edit'
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                10.0.kH,
                                ServicesText.ffText(
                                    "post-care instructions".tr),
                                20.0.kH,
                                ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: controller.prescription.length,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return 15.0.kH;
                                  },
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return _buildPreScriptRow(
                                        controller.prescription[index]);
                                  },
                                ),
                              ],
                            )
                          : const SizedBox.shrink(),
                      15.0.kH,
                      Center(
                        child: SizedBox(
                            width: context.screenWidth * .5,
                            // height: context.screenHeight * .05,
                            child: AppButton(
                                onTap: () async {
                                  if (controller.serviceImage.value == '' ||
                                      controller.description.text.isEmpty ||
                                      controller.title.text.isEmpty ||
                                      controller.price.text.isEmpty) {
                                    showSnackBar(
                                        "Make sure all fields are filed".tr,
                                        "Error".tr,
                                        AppTheme.lightAppColors.secondaryColor);
                                  } else {
                                    widget.type == 'edit'
                                        ? await controller.updateService(
                                            widget.serviceId!.serviceId)
                                        : controller.addService(context);
                                  }
                                },
                                title: widget.type == 'edit'
                                    ? "Edit".tr
                                    : "Add".tr)),
                      ),
                      60.0.kH,
                    ],
                  ),
                ),
              ),
            ),
            controller.isUpdating.value
                ? Container(
                    width: context.screenWidth,
                    height: context.screenHeight,
                    color: AppTheme.lightAppColors.background.withOpacity(0.2),
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
    );
  }

  _buildPreScriptRow(Prescription prescription) {
    return GestureDetector(
      onTap: () {
        controller.preDescription.text = prescription.description;
        editPrescription(context, controller, prescription);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Get.locale!.languageCode == 'en'
                  ? ServicesText.secText(
                      "Day: ${prescription.day.toString()}",
                    )
                  : ServicesText.secText(
                      "يوم : ${prescription.day.toString()}",
                    ),
              ServicesText.thirdText(
                prescription.description,
              ),
            ],
          ),
          const Spacer(),
          Icon(
            Icons.arrow_forward_ios_sharp,
            color: AppTheme.lightAppColors.black,
          )
        ],
      ),
    );
  }
}

Future<dynamic> addServiceServyPopUp(
  BuildContext context,
) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppTheme.lightAppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.all(10),
        content: SizedBox(
          width: context.screenWidth * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      backgroundColor: AppTheme.lightAppColors.background,
                      child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: AppTheme.lightAppColors.primary,
                          )),
                    ),
                  )
                ],
              ),
              10.0.kH,
              ServicesText.secText(
                  "Would you like to add any post-care instructions".tr),
              10.0.kH,
              10.0.kH,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: context.screenWidth * .3,
                    child: AppButton(
                      onTap: () {
                        Get.to(() => const AddPostInstructionWidget());
                      },
                      title: 'Yes'.tr,
                    ),
                  ),
                  Container(
                    width: context.screenWidth * .3,
                    height: context.screenHeight * .05,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: AppTheme.lightAppColors.primary)),
                    child: TextButton(
                      onPressed: () {
                        Get.back();
                        Get.back();
                      },
                      child: Text('No'.tr,
                          style: TextStyle(
                              color: AppTheme.lightAppColors.primary)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}

Future<dynamic> editPrescription(BuildContext context,
    VendorServicesController controller, Prescription prescription) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppTheme.lightAppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.all(10),
        content: SizedBox(
          width: context.screenWidth * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      backgroundColor: AppTheme.lightAppColors.background,
                      child: IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.close,
                            color: AppTheme.lightAppColors.primary,
                          )),
                    ),
                  )
                ],
              ),
              10.0.kH,
              ServicesText.secText("Description".tr),
              10.0.kH,
              AuthForm(
                  formModel: FormModel(
                      controller: controller.preDescription,
                      enableText: false,
                      hintText: "Description".tr,
                      invisible: false,
                      validator: null,
                      type: TextInputType.text,
                      inputFormat: [],
                      onTap: null)),
              10.0.kH,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: context.screenWidth * .3,
                    child: AppButton(
                      onTap: () {
                        controller.editPreInstruction(prescription);
                      },
                      title: 'Edit'.tr,
                    ),
                  ),
                  Container(
                    width: context.screenWidth * .3,
                    height: context.screenHeight * .05,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: AppTheme.lightAppColors.primary)),
                    child: TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text('Cancel'.tr,
                          style: TextStyle(
                              color: AppTheme.lightAppColors.primary)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
