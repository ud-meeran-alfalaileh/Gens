import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/question/controller/add_image_user_controller.dart';
import 'package:get/get.dart';

class UserThreeImage extends StatefulWidget {
  const UserThreeImage({super.key});

  @override
  State<UserThreeImage> createState() => _UserThreeImageState();
}

class _UserThreeImageState extends State<UserThreeImage> {
  final controller = Get.put(AddImageUserController());

  @override
  void initState() {
    super.initState();
    controller.getUserthreeImage();
  }

  // Show modal bottom sheet with options for camera and gallery
  void showImageSourceModal(BuildContext context, int index) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: context.screenHeight * .25,
          width: context.screenWidth,
          decoration: BoxDecoration(
              color: AppTheme.lightAppColors.background,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20))),
          child: Column(
            children: [
              SizedBox(height: context.screenHeight * .02),
              imageSourceButton(context, () {
                controller.pickImage(index);
                Navigator.of(context).pop();
              }, "Pick from Gallery", Icons.image_outlined),
              const Divider(),
              imageSourceButton(context, () {
                controller.takeIkmage(index);
                Navigator.of(context).pop();
              }, "Take a Photo", Icons.camera_alt_outlined),
            ],
          ),
        );
      },
    );
  }

  GestureDetector imageSourceButton(
      BuildContext context, VoidCallback onTap, String title, IconData icon) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppTheme.lightAppColors.black, size: 25),
          (15.0).kW,
          Container(
            width: context.screenWidth * .7,
            height: context.screenHeight * 0.05,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Baloo',
                fontSize: 16,
                color: AppTheme.lightAppColors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isLoading.value
        ? Scaffold(
            backgroundColor: AppTheme.lightAppColors.background,
            body: Center(
              child: CircularProgressIndicator(
                color: AppTheme.lightAppColors.primary,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: AppTheme.lightAppColors.background,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: AppTheme.lightAppColors.primary,
                          ),
                          onPressed: () {
                            _showConfirmationDialog(context);
                          },
                        ),
                      ],
                    ),
                    Text(
                      "Upload three photos of your face from various perspectives.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 24,
                        color: AppTheme.lightAppColors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    70.0.kH,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          // First Row with two images
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: imageCard(context, 0),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: imageCard(context, 1),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Single image in a column
                          imageCard(context, 2),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: context.screenWidth * .3,
                      child: AppButton(
                        onTap: () async {
                          await controller.saveImagesToApi();
                          Get.back();
                        },
                        title: "Save changes",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
  }

  // Widget to build each image card
  Widget imageCard(BuildContext context, int index) {
    return SizedBox(
      height: context.screenHeight * .25,
      width: context.screenWidth * .5,
      child: Stack(
        children: [
          Obx(() => Center(
                child: Container(
                  height: context.screenHeight * .25,
                  width: context.screenWidth * .5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300],
                  ),
                  child: controller.updatedImages[index] == null
                      ? (controller.imageUrls[index].isNotEmpty
                          ? Image.network(
                              controller.imageUrls[index],
                              fit: BoxFit.cover,
                            )
                          : const Icon(
                              Icons.image,
                              color: Colors.grey,
                              size: 50,
                            ))
                      : Image.file(
                          controller.updatedImages[index]!,
                          fit: BoxFit.cover,
                        ),
                ),
              )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                width: context.screenWidth * .2,
                height: context.screenHeight * .04,
                child: AppButton(
                  onTap: () => showImageSourceModal(context, index),
                  title: "Change",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightAppColors.background,
          title: Text('Confirm Changes'),
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
