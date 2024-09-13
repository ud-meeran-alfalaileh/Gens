import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/doctor_profile/model/service_model.dart';
import 'package:gens/src/feature/login/model/login_form_model.dart';
import 'package:gens/src/feature/login/view/widgte/collection/auth_form_widget.dart';
import 'package:gens/src/feature/vendor_services/controller/vendor_services_controller.dart';
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
    widget.type == 'edit' ? controller.setServiceData(widget.serviceId!) : null;
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
                        child: ServicesText.addMainText("Add service"),
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
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: controller.serviceImage.value != ""
                                        ? NetworkImage(
                                            controller.serviceImage.value,
                                          )
                                        : const AssetImage(
                                            "assets/image/addIamge.png"),
                                  ),
                                  border: Border.all(
                                      color: AppTheme.lightAppColors.primary),
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          18.0.kW,
                          SizedBox(
                            width: context.screenWidth * .5,
                            child: ServicesText.secText(
                                "pick image that will represend the service you will provide"),
                          ),
                        ],
                      ),
                      20.0.kH,
                      ServicesText.secText("Service Name"),
                      AuthForm(
                          formModel: FormModel(
                              controller: controller.title,
                              enableText: false,
                              hintText: "Service Name",
                              invisible: false,
                              validator: null,
                              type: TextInputType.text,
                              inputFormat: [],
                              onTap: () {})),
                      20.0.kH,
                      ServicesText.secText("Description"),
                      AuthForm(
                          maxLine: 4,
                          formModel: FormModel(
                              controller: controller.description,
                              enableText: false,
                              hintText: "Description",
                              invisible: false,
                              validator: null,
                              type: TextInputType.text,
                              inputFormat: [],
                              onTap: () {})),
                      20.0.kH,
                      ServicesText.secText("Price"),
                      AuthForm(
                          formModel: FormModel(
                              controller: controller.price,
                              enableText: false,
                              hintText: "Price",
                              invisible: false,
                              validator: null,
                              type: TextInputType.text,
                              inputFormat: [],
                              onTap: () {})),
                      20.0.kH,
                      Center(
                        child: SizedBox(
                            width: context.screenWidth * .5,
                            // height: context.screenHeight * .05,
                            child: AppButton(
                                onTap: () {
                                  widget.type == 'edit'
                                      ? controller.updateService(
                                          widget.serviceId!.serviceId)
                                      : controller.addService();
                                },
                                title: widget.type == 'edit' ? "Edit" : "Add")),
                      )
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
}
