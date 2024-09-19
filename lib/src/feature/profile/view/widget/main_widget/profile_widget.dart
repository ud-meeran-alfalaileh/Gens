import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/core/utils/loading_page.dart';
import 'package:gens/src/feature/profile/controller/profile_controller.dart';
import 'package:gens/src/feature/profile/view/page/profile_row_container.dart';
import 'package:gens/src/feature/profile/view/widget/collection/profile_collection.dart';
import 'package:gens/src/feature/profile/view/widget/collection/skin_details.dart';
import 'package:gens/src/feature/profile/view/widget/collection/update_profile.dart';
import 'package:gens/src/feature/profile/view/widget/text/profile_text.dart';
import 'package:get/get.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final controller = Get.put(ProfileController());
  User user = User();
  @override
  void initState() {
    initalState(context);
    super.initState();
  }

  Future<void> initalState(context) async {
    await user.loadToken();
    await controller.getUser(user.userId, context);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isLoading.value ||
            controller.isLoadingImg.value == true
        ? loadingPage(context)
        : Container(
            color: const Color(0xfff5f5f5),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: context.screenWidth,
                    height: context.screenHeight * .35,
                    child: Stack(
                      children: [
                        Container(
                          width: context.screenWidth,
                          height: context.screenHeight * .25,
                          decoration: BoxDecoration(
                              color: AppTheme.lightAppColors.primary),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 30,
                          child: GestureDetector(
                            onTap: () {
                              showPopupButtons(context, controller);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.lightAppColors.background),
                              child: CircleAvatar(
                                radius: 70,
                                backgroundColor: AppTheme.lightAppColors.black
                                    .withOpacity(0.1),
                                backgroundImage: controller
                                                .userData.value!.userImage ==
                                            "" ||
                                        controller.userData.value!.userImage ==
                                            "string"
                                    ? const AssetImage(
                                        "assets/image/profileIcon.png")
                                    : NetworkImage(
                                        controller.userData.value!.userImage ??
                                            ''),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileText.mainText(
                            "${controller.userData.value?.fName} ${controller.userData.value?.secName}"),
                        ProfileText.secText(
                            "+962${controller.removeLeadingZero(controller.userData.value!.phone)}"),
                        5.0.kH,
                        ProfileText.secText(
                            "Age : ${controller.dateOfBirth.text}"),
                      ],
                    ),
                  ),
                  profileContainerRow(controller),

                  Container(
                    color: AppTheme.lightAppColors.background,
                    width: context.screenWidth,
                    height: context.screenHeight,
                    // padding: EdgeInsets.all(20),
                    child: Obx(() {
                      switch (controller.selectedIndex.value) {
                        case 0:
                          return SkinDetailsPage(
                            gender: controller.userData.value!.gender,
                          );
                        case 1:
                          return UpdateProfile();

                        default:
                          return Container();
                      }
                    }),
                  ),
                  // profileRow(
                  //     Icon(
                  //       Icons.logout,
                  //       color: AppTheme.lightAppColors.primary,
                  //     ),
                  //     "Logout", () {
                  //   controller.logout();
                  // }),
                  // TextButton(
                  //     onPressed: () {
                  //       Get.to(() => FirstQuestionPageView());
                  //     },
                  //     child: Text("data")),
                  // (context.screenHeight * .01).kH,
                ],
              ),
            ),
          ));
  }

  profileRow(icon, text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            icon,
            15.0.kW,
            Text(text),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 15,
            )
          ],
        ),
      ),
    );
  }
}
