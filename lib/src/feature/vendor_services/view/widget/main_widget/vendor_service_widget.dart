import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/short_text.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/dashboard/view/widget/collection/dashboard_shimmer.dart';
import 'package:gens/src/feature/doctor_profile/model/service_model.dart';
import 'package:gens/src/feature/vendor_dashboard/view/widget/text/vendor_dashboard_text.dart';
import 'package:gens/src/feature/vendor_services/controller/vendor_services_controller.dart';
import 'package:gens/src/feature/vendor_services/view/widget/main_widget/add_service_widget.dart';
import 'package:gens/src/feature/vendor_services/view/widget/text/services_text.dart';
import 'package:get/get.dart';

class VendorServiceWidget extends StatefulWidget {
  const VendorServiceWidget({super.key});

  @override
  State<VendorServiceWidget> createState() => _VendorServiceWidgetState();
}

class _VendorServiceWidgetState extends State<VendorServiceWidget> {
  final controller = Get.put(VendorServicesController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        controller.getVendorServices();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
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
                      Icons.arrow_back_ios_new,
                      color: AppTheme.lightAppColors.primary,
                    )),
                Image.asset(
                  "assets/image/logo.png",
                  height: 50,
                  width: 100,
                  fit: BoxFit.fitWidth,
                ),
              ],
            ),
            const Divider(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      VendorDashboardText.mainText("My Services".tr),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const AddServiceWidget(
                                type: 'add',
                              ));
                        },
                        child: ServicesText.addSrviceText("Add services +".tr),
                      )
                    ],
                  ),
                ),
                20.0.kH,
                Obx(
                  () => controller.isUpdating.value
                      ? dashboardShimmer()
                      : controller.services.isEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    100.0.kH,
                                    Image.asset(
                                      'assets/image/empty-box.png',
                                      width: 200,
                                    ),
                                    10.0.kH,
                                    VendorDashboardText.emptyText(
                                        "Currently, there are no Services add for you"
                                            .tr),
                                  ],
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18.0),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final service = controller.services[index];
                                return GestureDetector(
                                  onTap: () {
                                    servicePopUp(context, service);
                                  },
                                  child:
                                      vendorServicesContainer(context, service),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return 15.0.kH;
                              },
                              itemCount: controller.services.length,
                            ),
                )
              ],
            ),
            100.0.kH
          ],
        ),
      ),
    );
  }

  vendorServicesContainer(BuildContext context, Services service) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: context.screenWidth,
      height: context.screenHeight * .2,
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.lightAppColors.maincolor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Container(
                width: context.screenWidth * .3,
                height: context.screenHeight * .3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                        image: NetworkImage(
                          service.imageUrl,
                        ),
                        fit: BoxFit.cover)),
              ),
              10.0.kW,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ServicesText.secText(service.title),
                  SizedBox(
                    width: context.screenWidth * .5,
                    child: ServicesText.thirdText(
                        serviceShortText(service.description)),
                  ),
                ],
              ),
            ],
          ),
          Align(
            alignment: Get.locale!.languageCode == 'en'
                ? Alignment.bottomRight
                : Alignment.bottomLeft,
            child: ServicesText.mainText("${service.price.toString()} JD"),
          )
        ],
      ),
    );
  }

  Future<dynamic> servicePopUp(BuildContext context, Services service) {
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
                    Center(
                      child: Image.network(
                        service.imageUrl,
                        width: context.screenWidth * .5,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ServicesText.secText(service.title),
                    ServicesText.mainText("${service.price.toString()} JOD"),
                  ],
                ),
                10.0.kH,
                ServicesText.mainText(service.description),
                10.0.kH,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: context.screenWidth * .3,
                      child: AppButton(
                        color: AppTheme.lightAppColors.secondaryColor,
                        onTap: () {
                          controller.deleteService(service.serviceId);
                        },
                        title: 'Delete'.tr,
                      ),
                    ),
                    Container(
                      width: context.screenWidth * .3,
                      height: context.screenHeight * .05,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppTheme.lightAppColors.primary)),
                      child: TextButton(
                        onPressed: () {
                          Get.back();

                          Get.to(() => AddServiceWidget(
                                type: 'edit',
                                serviceId: service,
                              ));
                        },
                        child: Text('Edit'.tr,
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
}
