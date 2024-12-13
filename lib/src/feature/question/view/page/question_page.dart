import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/profile/controller/profile_controller.dart';
import 'package:gens/src/feature/question/controller/add_image_user_controller.dart';
import 'package:gens/src/feature/question/controller/first_question_controller.dart';
import 'package:gens/src/feature/question/view/widget/collection/add_image.dart';
import 'package:gens/src/feature/question/view/widget/collection/add_product_widget.dart';
import 'package:gens/src/feature/question/view/widget/main_widget/first_qustion_widget.dart';
import 'package:gens/src/feature/question/view/widget/main_widget/fourth_question_page.dart';
import 'package:gens/src/feature/question/view/widget/main_widget/second_question_page.dart';
import 'package:gens/src/feature/question/view/widget/main_widget/skin_qoal_page.dart';
import 'package:gens/src/feature/question/view/widget/main_widget/third_question_page.dart';
import 'package:get/get.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage(
      {super.key,
      required this.gender,
      required this.type,
      required this.from});
  final String gender;
  final String type;
  final String from;

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final controller = Get.put(FirstQuestionController());
  final profileController = Get.put(ProfileController());
  final imageController = Get.put(AddImageUserController());
  @override
  void initState() {
    super.initState();
    profileController.getQuestionDetails();

    if (widget.type == "Empty") {
      // Schedule navigation after the current frame is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.to(() =>
            FirstQuestionPageView(gender: widget.gender, from: widget.from));
      });
    }
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
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Icon(Icons.arrow_back_ios))
                        ],
                      ),
                      20.0.kH,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Obx(
                            () => Stack(
                              children: [
                                sectionButton(context, "Skin Type", () {
                                  Get.to(() => FirstQuestionPageView(
                                        gender: widget.gender,
                                        from: "Update",
                                      ));
                                }, 50, 'assets/image/testSkin.avif'),
                                profileController.isFirstDataIncomplete.value
                                    ? Icon(
                                        Icons.error,
                                        color: AppTheme
                                            .lightAppColors.secondaryColor,
                                      )
                                    : const SizedBox.shrink()
                              ],
                            ),
                          ),
                          Obx(
                            () => Stack(
                              children: [
                                sectionButton(context, 'Hormonal & GI', () {
                                  Get.to(() => SecondQuestionPageView(
                                        gender: widget.gender,
                                        from: 'Update',
                                      ));
                                }, 100, 'assets/image/testSkin.avif'),
                                profileController.isSecDataIncomplete.value
                                    ? Icon(
                                        Icons.error,
                                        color: AppTheme
                                            .lightAppColors.secondaryColor,
                                      )
                                    : const SizedBox.shrink()
                              ],
                            ),
                          )
                        ],
                      ),
                      20.0.kH,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Obx(
                            () => Stack(
                              children: [
                                sectionButton(context, "Life Style", () {
                                  Get.to(() => const ThirdQuestionPageView(
                                        from: 'Update',
                                      ));
                                }, 150, 'assets/image/testSkin.avif'),
                                profileController.isThirdDataIncomplete.value
                                    ? Icon(
                                        Icons.error,
                                        color: AppTheme
                                            .lightAppColors.secondaryColor,
                                      )
                                    : const SizedBox.shrink()
                              ],
                            ),
                          ),
                          Stack(
                            children: [
                              sectionButton(context, "History check", () {
                                Get.to(() => const FourthQuestionPageView(
                                      from: 'Update',
                                    ));
                              }, 250, 'assets/image/testSkin.avif'),
                              Obx(() =>
                                  profileController.isFifthDataIncomplete.value
                                      ? Icon(
                                          Icons.error,
                                          color: AppTheme
                                              .lightAppColors.secondaryColor,
                                        )
                                      : const SizedBox.shrink())
                            ],
                          ),
                        ],
                      ),
                      20.0.kH,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Stack(
                            children: [
                              sectionButton(context, "Skin Goals", () {
                                Get.to(() => const SkinQoalQuestionPageView());
                              }, 200, 'assets/image/testSkin.avif'),
                              profileController.isFourthDataIncomplete.value
                                  ? Icon(
                                      Icons.error,
                                      color: AppTheme
                                          .lightAppColors.secondaryColor,
                                    )
                                  : const SizedBox.shrink()
                            ],
                          ),
                          Stack(
                            children: [
                              sectionButton(context, "Face Image", () {
                                Get.to(() => const UserThreeImage());
                              }, 300, 'assets/image/testSkin.avif'),
                              imageController.isImageDataIncomplere.value
                                  ? Icon(
                                      Icons.error,
                                      color: AppTheme
                                          .lightAppColors.secondaryColor,
                                    )
                                  : const SizedBox.shrink()
                            ],
                          )
                        ],
                      ),
                      20.0.kH,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          10.0.kW,
                          SizedBox(
                            width: context.screenWidth * .4,
                            height: context.screenHeight * .18,
                            child: Stack(
                              children: [
                                sectionButton(context, "Product", () {
                                  Get.to(() => const AddProductWidget());
                                }, 350, 'assets/image/testSkin.avif'),
                              ],
                            ),
                          ),
                          // productController.isProductIncomplete.value
                          //     ? const Icon(
                          //         Icons.error,
                          //         color: Colors.red,
                          //       )
                          //     : const SizedBox.shrink()
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  sectionButton(BuildContext context, title, VoidCallback ontap, duration,
      String assetName) {
    return DelayedDisplay(
      delay: Duration(milliseconds: duration),
      child: GestureDetector(
        onTap: ontap,
        child: Stack(
          children: [
            Container(
              width: context.screenWidth * .4,
              height: context.screenHeight * .18,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(assetName), fit: BoxFit.cover),
                  border: Border.all(color: AppTheme.lightAppColors.maincolor),
                  borderRadius: BorderRadius.circular(20),
                  color: AppTheme.lightAppColors.maincolor.withOpacity(0.8)),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              width: context.screenWidth * .4,
              height: context.screenHeight * .18,
              decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.lightAppColors.maincolor),
                  borderRadius: BorderRadius.circular(20),
                  color: AppTheme.lightAppColors.black.withOpacity(0.4)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        color: AppTheme.lightAppColors.background,
                        fontSize: 18,
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
