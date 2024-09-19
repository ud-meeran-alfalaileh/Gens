import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/vendor_dashboard/view/widget/text/vendor_dashboard_text.dart';
import 'package:gens/src/feature/vendor_profile/controller/vendor_profile_controller.dart';
import 'package:get/get.dart';

class EditImagesPage extends StatefulWidget {
  const EditImagesPage({
    super.key,
  });

  @override
  _EditImagesPageState createState() => _EditImagesPageState();
}

class _EditImagesPageState extends State<EditImagesPage> {
  final controller = Get.put(VendorProfileController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? Container(
              width: context.screenWidth,
              height: context.screenHeight,
              color: Colors.black.withOpacity(0.1),
              child: CircularProgressIndicator(
                color: AppTheme.lightAppColors.primary,
              ),
            )
          : WillPopScope(
              onWillPop: () async {
                if (controller.isLoading.value) {
                  return false; // Prevent the pop action if loading
                }
                _showConfirmationDialog(context);
                return false; // Return false to prevent the default pop behavior
              },
              child: Scaffold(
                backgroundColor: AppTheme.lightAppColors.background,
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Obx(
                      () => Column(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: AppTheme.lightAppColors.primary,
                                ),
                                onPressed: () {
                                  controller.isLoading.value
                                      ? null
                                      : _showConfirmationDialog(context);
                                }, // Save action
                              ),
                            ],
                          ),
                          Text(
                            "Click on the image you want \nto change",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 24,
                              color: AppTheme.lightAppColors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          // if (controller.isLoading.value) CircularProgressIndicator(),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.imageUrls.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  Obx(
                                    () => Center(
                                      child: Container(
                                        height: 200,
                                        width: context.screenWidth * .8,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: controller
                                                        .updatedImages[index] !=
                                                    null
                                                ? FileImage(controller
                                                    .updatedImages[index]!)
                                                : NetworkImage(controller
                                                        .imageUrls[index])
                                                    as ImageProvider,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40.0, vertical: 10),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: SizedBox(
                                        width: context.screenWidth * .2,
                                        height: context.screenHeight * .04,
                                        child: AppButton(
                                            onTap: () => controller.pickImage(
                                                index), // Pick a new image
                                            title: "Change"),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return 10.0.kH;
                            },
                          ),
                          10.0.kH,
                          SizedBox(
                            width: context.screenWidth * .3,
                            child: AppButton(
                                onTap: () async {
                                  await controller.saveImagesToApi();
                                  Get.back();
                                },
                                title: "Save changes"),
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

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to close
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightAppColors.background,
          title: VendorDashboardText.emptyText('Confirm Changes'),
          content: const Text(
            'Do you want to save changes or discard them?',
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Discard',
                style: TextStyle(
                    color: AppTheme.lightAppColors.primary,
                    fontFamily: "Inter"),
              ),
              onPressed: () {
                Get.back();
                Get.back();
              },
            ),
            TextButton(
              child: Text(
                'Continue',
                style: TextStyle(
                    color: AppTheme.lightAppColors.primary,
                    fontFamily: "Inter"),
              ),
              onPressed: () async {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
