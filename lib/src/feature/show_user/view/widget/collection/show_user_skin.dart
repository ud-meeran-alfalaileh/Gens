import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/profile/model/question_model.dart';
import 'package:gens/src/feature/profile/view/widget/text/skin_text.dart';
import 'package:gens/src/feature/show_user/controller/show_user_controller.dart';
import 'package:get/get.dart';

class ShowUserSkin extends StatelessWidget {
  final String gender;

  const ShowUserSkin({super.key, required this.gender});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShowUserController());
    // final data = controller.question.value;

    return Obx(
      () => SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: controller.question.value == null
            ? const SizedBox.shrink()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.0.kH,
                  skinDetailsContainer(
                      controller.question.value!,
                      context,
                      'Skin Type',
                      controller.question.value?.skinTypeMorning,
                      "assets/image/perfect-skin.png"),
                  controller.question.value!.skinConcerns == ""
                      ? const SizedBox.shrink()
                      : skinDetailsContainer(
                          controller.question.value,
                          context,
                          'Skin concern',
                          controller.question.value!.skinConcerns,
                          "assets/image/concern.png"),
                  controller.question.value!.acneMedication == ""
                      ? const SizedBox.shrink()
                      : skinDetailsContainer(
                          controller.question.value!,
                          context,
                          'Isotretinoin Use',
                          controller.question.value!.acneMedication,
                          "assets/image/capsules.png"),
                  controller.question.value?.waterConsume == ''
                      ? const SizedBox.shrink()
                      : lifeStyle(context, controller.question.value!),
                  10.0.kH,
                  controller.question.value!.foodConsume == ""
                      ? const SizedBox.shrink()
                      : skinDetailsContainer(
                          controller.question.value!,
                          context,
                          'Dietary Habits',
                          controller.question.value!.foodConsume,
                          "assets/image/bibimbap.png"),
                  controller.question.value!.b12Pills == ""
                      ? const SizedBox.shrink()
                      : skinDetailsContainer(
                          controller.question.value!,
                          context,
                          'Vitamin B12',
                          controller.question.value!.b12Pills,
                          'assets/image/capsules.png'),
                  controller.question.value!.manageStress == ""
                      ? const SizedBox.shrink()
                      : skinDetailsContainer(
                          controller.question.value!,
                          context,
                          'Stress Mange',
                          controller.question.value!.manageStress,
                          "assets/image/stress.png"),
                  if (gender == "Female")
                    Column(
                      children: [
                        skinDetailsContainer(
                            controller.question.value!,
                            context,
                            'Period Type',
                            controller.question.value!.femalePeriodType == "No"
                                ? "Irregular"
                                : "Regular",
                            'assets/image/female.png'),
                        skinDetailsContainer(
                            controller.question.value!,
                            context,
                            'Having Period Problem',
                            controller.question.value!.femaleHormoneRelated,
                            'assets/image/female.png'),
                        if (controller.message.text != "")
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
                                          image: FileImage(
                                              controller.updatedImage.value!))),
                                ),
                                10.0.kH,
                                SkinText.mainText(
                                    "Product recently used: ${controller.message.text}"),
                                10.0.kH,
                              ],
                            ),
                          ),
                        if (controller.isImageDataIncomplere.value == false)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SkinText.mainText("Face Images"),
                              5.0.kH,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: context.screenHeight * .12,
                                    height: context.screenHeight * .1,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                controller.imageUrls[0])),
                                        border: Border.all(
                                            color: AppTheme
                                                .lightAppColors.bordercolor),
                                        color:
                                            AppTheme.lightAppColors.background,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  Container(
                                    width: context.screenHeight * .12,
                                    height: context.screenHeight * .1,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                controller.imageUrls[1])),
                                        border: Border.all(
                                            color: AppTheme
                                                .lightAppColors.bordercolor),
                                        color:
                                            AppTheme.lightAppColors.background,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                  Container(
                                    width: context.screenHeight * .12,
                                    height: context.screenHeight * .1,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                controller.imageUrls[2])),
                                        border: Border.all(
                                            color: AppTheme
                                                .lightAppColors.bordercolor),
                                        color:
                                            AppTheme.lightAppColors.background,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ],
                    ),
                  150.0.kH,
                ],
              ),
      ),
    );
  }

  skinDetailsContainer(
      SkinCareModel? data, BuildContext context, title, answer, imag) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
              horizontal: context.screenWidth * .02,
              vertical: context.screenHeight * .01),
          width: context.screenWidth,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppTheme.lightAppColors.background,
              border: Border.all(color: AppTheme.lightAppColors.bordercolor)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                imag,
                width: 60,
              ),
              20.0.kW,
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkinText.mainText(title),
                  SizedBox(
                    width: context.screenWidth * .6,
                    child: SkinText.subMainText(answer),
                  )
                ],
              )
            ],
          ),
        ),
        10.0.kH
      ],
    );
  }

  Container femaleRelatedContainer(BuildContext context, SkinCareModel? data) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: context.screenWidth,
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

  // questionButton(BuildContext context, String gender) {
  //   return GestureDetector(
  //     onTap: () {
  //       Get.to(() => QuestionPage(
  //             gender: gender,
  //           ));
  //     },
  //     child: Container(
  //       padding: const EdgeInsets.all(10),
  //       width: context.screenWidth,
  //       height: context.screenHeight * .13,
  //       decoration: BoxDecoration(
  //           color: AppTheme.lightAppColors.background,
  //           borderRadius: BorderRadius.circular(10)),
  //       child: Row(
  //         children: [
  //           Container(
  //             width: 5,
  //             height: context.screenHeight * .1,
  //             decoration: BoxDecoration(
  //                 color: AppTheme.lightAppColors.maincolor,
  //                 borderRadius: BorderRadius.circular(30)),
  //           ),
  //           10.0.kW,
  //           Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Row(
  //                 children: [
  //                   SkinText.questionText('Create Profile '),
  //                   ProfileText.secText('5 min'),
  //                 ],
  //               ),
  //               SkinText.secText(
  //                   'To continue building your profile, start Questionnaire.')
  //             ],
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

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
          ),
          SkinText.subSecText(text)
        ],
      ),
    );
  }
}
