import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/profile/controller/profile_controller.dart';
import 'package:gens/src/feature/profile/model/question_model.dart';
import 'package:gens/src/feature/profile/view/widget/text/profile_text.dart';
import 'package:gens/src/feature/profile/view/widget/text/skin_text.dart';
import 'package:gens/src/feature/question/controller/add_image_user_controller.dart';
import 'package:gens/src/feature/question/controller/add_product_controller.dart';
import 'package:gens/src/feature/question/view/page/question_page.dart';
import 'package:get/get.dart';

class SkinDetailsPage extends StatelessWidget {
  final String gender;

  const SkinDetailsPage({super.key, required this.gender});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final isQuestionAvailable = controller.question.value != null;

    final imageController = Get.put(AddImageUserController());
    final productController = Get.put(AddProductController());
    RxBool isDataIncomplete = RxBool(isQuestionAvailable &&
        [
          controller.question.value?.skinTypeMorning ?? "",
          controller.question.value?.skinConcerns ?? "",
          controller.question.value?.skinIssue ?? "",
          controller.question.value?.maritalStatus ?? "",
          // Append female-specific fields if gender is Female
          if (gender == "Female")
            controller.question.value?.femaleHormoneRelated ?? "",
          if (gender == "Female")
            controller.question.value?.femalePeriodType ?? "",
          controller.question.value?.foodConsume ?? "",
          controller.question.value?.issuesFrequentlyExperience ?? "",
          controller.question.value?.waterConsume ?? "",
          controller.question.value?.sleepingHours ?? "",
          controller.question.value?.exerciseRoutine ?? "",
          controller.question.value?.smokingStatus ?? "",
          controller.question.value?.stressLevel ?? "",
          controller.question.value?.mainSkincareGoals ?? "",
          controller.question.value?.acneMedication ?? "",
          controller.question.value?.b12Pills ?? "",
        ].every((field) => field == ""));

    return Container(
      color: const Color(0xfff5f5f5),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Obx(
          () => SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isDataIncomplete.isTrue ||
                    controller.question.value == null)
                  questionButton(context, gender),
                if (controller.question.value != null) ...[
                  if (controller.question.value!.skinTypeMorning != "")
                    skinDetailsContainer(
                        controller.question.value!,
                        context,
                        'Skin Type',
                        controller.question.value?.skinTypeMorning,
                        "assets/image/perfect-skin.png"),
                  if (controller.question.value!.skinConcerns != "")
                    skinDetailsContainer(
                        controller.question.value!,
                        context,
                        'Skin concern',
                        controller.question.value!.skinConcerns,
                        "assets/image/dry-skin.png"),
                  if (controller.question.value!.skinIssue != "")
                    skinDetailsContainer(
                        controller.question.value!,
                        context,
                        'Skin Issue',
                        controller.question.value!.skinIssue,
                        "assets/image/burn.png"),
                  if (controller.question.value!.acneMedication != "")
                    skinDetailsContainer(
                        controller.question.value!,
                        context,
                        'Isotretinoin Use',
                        controller.question.value!.acneMedication,
                        "assets/image/capsules.png"),
                  controller.question.value!.waterConsume == ''
                      ? const SizedBox.shrink()
                      : lifeStyle(context, controller.question.value!),
                  10.0.kH,
                  if (controller.question.value!.foodConsume != "")
                    skinDetailsContainer(
                        controller.question.value!,
                        context,
                        'Dietary Habits',
                        controller.question.value!.foodConsume,
                        "assets/image/bibimbap.png"),
                  if (controller.question.value!.b12Pills != "")
                    skinDetailsContainer(
                        controller.question.value!,
                        context,
                        'Vitamin B12',
                        controller.question.value!.b12Pills,
                        "assets/image/vitamin-b12.png"),
                  if (controller.question.value!.manageStress != "")
                    skinDetailsContainer(
                        controller.question.value!,
                        context,
                        'Stress Manage',
                        controller.question.value!.manageStress,
                        "assets/image/stress.png"),
                  //assets/image/female.png
                  if (gender == "Female")
                    controller.question.value!.femaleHormoneRelated == ''
                        ? const SizedBox.shrink()
                        : Column(
                            children: [
                              skinDetailsContainer(
                                  controller.question.value!,
                                  context,
                                  'Period Type',
                                  controller.question.value!.femalePeriodType ==
                                          "No"
                                      ? "Irregular"
                                      : "Regular",
                                  'assets/image/female.png'),
                              skinDetailsContainer(
                                  controller.question.value!,
                                  context,
                                  'Having Period Problem',
                                  controller
                                      .question.value!.femaleHormoneRelated,
                                  'assets/image/female.png'),
                            ],
                          ),
                  10.0.kH,
                  if (productController.message.text != "")
                    Container(
                      width: context.screenHeight,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: AppTheme.lightAppColors.bordercolor),
                          color: AppTheme.lightAppColors.background,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Container(
                            width: context.screenWidth * .9,
                            height: context.screenHeight * .2,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: FileImage(productController
                                        .updatedImage.value!))),
                          ),
                          10.0.kH,
                          SkinText.mainText(
                              "Product recently used: ${productController.message.text}"),
                          10.0.kH,
                        ],
                      ),
                    ),
                  10.0.kH,

                  if (imageController.imageUrls.isNotEmpty)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkinText.mainText("Face Images"),
                        5.0.kH,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          imageController.imageUrls[0],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: context.screenHeight * .12,
                                height: context.screenHeight * .1,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            imageController.imageUrls[0])),
                                    border: Border.all(
                                        color: AppTheme
                                            .lightAppColors.bordercolor),
                                    color: AppTheme.lightAppColors.background,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          imageController.imageUrls[1],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: context.screenHeight * .12,
                                height: context.screenHeight * .1,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            imageController.imageUrls[1])),
                                    border: Border.all(
                                        color: AppTheme
                                            .lightAppColors.bordercolor),
                                    color: AppTheme.lightAppColors.background,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          imageController.imageUrls[2],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                width: context.screenHeight * .12,
                                height: context.screenHeight * .1,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            imageController.imageUrls[2])),
                                    border: Border.all(
                                        color: AppTheme
                                            .lightAppColors.bordercolor),
                                    color: AppTheme.lightAppColors.background,
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
                150.0.kH,
              ],
            ),
          ),
        ),
      ),
    );
  }

  skinDetailsContainer(SkinCareModel? data, BuildContext context, String title,
      String? answer, String image) {
    if (answer == null || answer.isEmpty) {
      return const SizedBox
          .shrink(); // Return empty if the answer is null or empty
    }
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.screenWidth * .03,
            vertical: context.screenHeight * .03,
          ),
          width: context.screenWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppTheme.lightAppColors.background,
            border: Border.all(color: AppTheme.lightAppColors.bordercolor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                image,
                width: 30,
              ),
              20.0.kW,
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkinText.mainText(title),
                  SizedBox(
                    width: context.screenWidth * .7,
                    child: SkinText.subMainText(answer),
                  ),
                ],
              ),
            ],
          ),
        ),
        10.0.kH,
      ],
    );
  }

  Container femaleRelatedContainer(BuildContext context, SkinCareModel? data) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: context.screenWidth,
      height: context.screenHeight * .09,
      decoration: BoxDecoration(
          color: AppTheme.lightAppColors.background,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              10.0.kW,
              SkinText.mainText('Period Type: '),
              SkinText.subMainText(
                  data?.femalePeriodType == "No" ? "Irregular" : "Regular")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.0.kW,
              SkinText.mainText('Having Period Problem: '),
              SkinText.subMainText(data?.femaleHormoneRelated)
            ],
          ),
        ],
      ),
    );
  }

  questionButton(BuildContext context, String gender) {
    return GestureDetector(
      onTap: () {
        Get.to(() => QuestionPage(
              gender: gender,
            ));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        width: context.screenWidth,
        height: context.screenHeight * .13,
        decoration: BoxDecoration(
            color: AppTheme.lightAppColors.background,
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Container(
              width: 5,
              height: context.screenHeight * .1,
              decoration: BoxDecoration(
                  color: AppTheme.lightAppColors.maincolor,
                  borderRadius: BorderRadius.circular(30)),
            ),
            10.0.kW,
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SkinText.questionText('Create Profile '),
                    ProfileText.secText('5 min'),
                  ],
                ),
                SkinText.secText(
                    'To continue building your profile, start Questionnaire.')
              ],
            )
          ],
        ),
      ),
    );
  }

  lifeStyle(BuildContext context, SkinCareModel data) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            profileSkinContainer(
                context, 'assets/image/water-glass.png', data.waterConsume),
            20.0.kW,
            profileSkinContainer(
                context, 'assets/image/sleep.png', data.sleepingHours),
          ],
        ),
        10.0.kH,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            profileSkinContainer(
                context, 'assets/image/dumbbell.png', data.exerciseRoutine),
            20.0.kW,
            profileSkinContainer(
                context, 'assets/image/cigarette.png', data.smokingStatus),
          ],
        ),
      ],
    );
  }

  Container profileSkinContainer(
      BuildContext context, String img, String text) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: context.screenWidth * .4,
      decoration: BoxDecoration(
          color: AppTheme.lightAppColors.background,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Image.asset(
            img,
            height: 100,
          ),
          SkinText.subSecText(text)
        ],
      ),
    );
  }
}
