import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/core/utils/loading_page.dart';
import 'package:gens/src/feature/login/model/login_form_model.dart';
import 'package:gens/src/feature/login/view/widgte/collection/auth_form_widget.dart';
import 'package:gens/src/feature/question/controller/add_product_controller.dart';
import 'package:get/get.dart';

class AddProductWidget extends StatelessWidget {
  const AddProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddProductController());

    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: Obx(
        () => controller.isLoading.value
            ? loadingPage(context)
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                              Get.back();
                              controller.getProduct();
                            },
                          ),
                        ],
                      ),
                      Text(
                        "Could you please upload a photo of all skincare and makeup products you have used in the last month?",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 24,
                          color: AppTheme.lightAppColors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // User ID Field
                      AuthForm(
                        maxLine: 6,
                        formModel: FormModel(
                            controller: controller.message,
                            enableText: false,
                            hintText:
                                "Please provide a brief description of the product.",
                            invisible: false,
                            validator: null,
                            type: TextInputType.text,
                            inputFormat: [],
                            onTap: null),
                      ),
                      const SizedBox(height: 10),

                      // Display Image Card
                      Obx(() => controller.isLoading.value
                          ? const CircularProgressIndicator()
                          : imageCard(context, controller)),

                      const SizedBox(height: 20),

                      // Submit Button
                      AppButton(
                        onTap: () async {
                          // Validate if the image and message are provided
                          if (controller.updatedImage.value == null) {
                            Get.snackbar(
                                "Error", "Please select an image first");
                            return; // Exit the function if no image is selected
                          }

                          if (controller.message.text.isEmpty) {
                            Get.snackbar("Error",
                                "Please provide a product description");
                            return; // Exit the function if the message is empty
                          }

                          // If both validations pass, upload the image
                          await controller.uploadImageToFirebase(
                              controller.updatedImage.value!);
                        },
                        title: "Submit",
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget imageCard(BuildContext context, AddProductController controller) {
    return SizedBox(
      height: context.screenHeight * .25,
      // width: context.screenWidth * .8,
      child: Stack(
        children: [
          Center(
            child: Container(
              height: context.screenHeight * .25,
              width: context.screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[300],
              ),
              child: controller.updatedImage.value == null
                  ? const Icon(
                      Icons.image,
                      color: Colors.grey,
                      size: 50,
                    )
                  : Image.file(
                      controller.updatedImage.value!,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                width: context.screenWidth * .25,
                height: context.screenHeight * .04,
                child: AppButton(
                  onTap: () => showImageSourceModal(context, controller),
                  title: "Add Image",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showImageSourceModal(BuildContext context, controller) {
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
                controller.pickImage();
                Navigator.of(context).pop();
              }, "Pick from Gallery", Icons.image_outlined),
              const Divider(),
              imageSourceButton(context, () {
                controller.takeIkmage();
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
}
