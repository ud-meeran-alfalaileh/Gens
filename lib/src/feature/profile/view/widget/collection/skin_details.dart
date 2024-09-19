import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/profile/controller/profile_controller.dart';
import 'package:gens/src/feature/profile/model/question_model.dart';
import 'package:gens/src/feature/profile/view/widget/text/profile_text.dart';
import 'package:gens/src/feature/profile/view/widget/text/skin_text.dart';
import 'package:gens/src/feature/question/view/page/question_page.dart';
import 'package:get/get.dart';

class SkinDetailsPage extends StatelessWidget {
  final String gender;

  const SkinDetailsPage({super.key, required this.gender});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final data = controller.question.value;

    return Container(
      color: const Color(0xfff5f5f5),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: !controller.buildProfile.value
              ? questionButton(context, gender)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: context.screenWidth * .5,
                        height: context.screenHeight * .3,
                        decoration: BoxDecoration(
                            color: AppTheme.lightAppColors.background,
                            borderRadius: BorderRadius.circular(30)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/image/skin-care.png',
                              width: 100,
                            ),
                            SkinText.mainText('Skin Goal '),
                            SkinText.subMainText(data?.mainSkincareGoals)
                          ],
                        ),
                      ),
                    ),
                    20.0.kH,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/image/perfect-skin.png",
                          width: 20,
                        ),
                        10.0.kW,
                        SkinText.mainText('Skin Type: '),
                        SkinText.subMainText(data?.skinTypeMorning)
                      ],
                    ),
                    10.0.kH,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/image/concern.png",
                            width: 20,
                          ),
                          10.0.kW,
                          SkinText.mainText("Skin concern: "),
                          SkinText.subMainText(data?.skinConcerns)
                        ],
                      ),
                    ),
                    10.0.kH,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/image/sensitive.png",
                            width: 20,
                          ),
                          10.0.kW,
                          SkinText.mainText("Skin Issue: "),
                          SkinText.subMainText(data?.skinIssue)
                        ],
                      ),
                    ),
                    30.0.kH,
                    lifeStyle(context, data!),
                    30.0.kH,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/image/bibimbap.png",
                            width: 20,
                          ),
                          10.0.kW,
                          SkinText.mainText('Dietary Habits : '),
                          SkinText.subMainText(data.foodConsume),
                        ],
                      ),
                    ),
                    10.0.kH,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/image/capsules.png",
                            width: 20,
                          ),
                          10.0.kW,
                          SkinText.mainText('Isotretinoin Use : '),
                          SkinText.subMainText(data.acneMedication),
                        ],
                      ),
                    ),
                    10.0.kH,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/image/vitamin-b12.png",
                            width: 20,
                          ),
                          10.0.kW,
                          SkinText.mainText('Vitamin B12 : '),
                          SkinText.subMainText(data.b12Pills),
                        ],
                      ),
                    ),
                    30.0.kH,
                    gender == "Female"
                        ? femaleRelatedContainer(context, data)
                        : const SizedBox.shrink(),
                    150.0.kH,
                  ],
                ),
        ),
      ),
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

  SingleChildScrollView lifeStyle(BuildContext context, SkinCareModel data) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          profileSkinContainer(
              context, 'assets/image/water-glass.png', data.waterConsume),
          20.0.kW,
          profileSkinContainer(
              context, 'assets/image/sleep.png', data.sleepingHours),
          20.0.kW,
          profileSkinContainer(
              context, 'assets/image/dumbbell.png', data.exerciseRoutine),
          20.0.kW,
          profileSkinContainer(
              context, 'assets/image/cigarette.png', data.smokingStatus),
          20.0.kW,
          profileSkinContainer(
              context, 'assets/image/stress.png', data.stressLevel),
          20.0.kW,
        ],
      ),
    );
  }

  Container profileSkinContainer(
      BuildContext context, String img, String text) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: context.screenWidth * .5,
      height: context.screenHeight * .2,
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
