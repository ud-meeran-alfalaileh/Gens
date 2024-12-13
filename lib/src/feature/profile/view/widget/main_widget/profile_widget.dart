import 'package:flutter/material.dart';
import 'package:gens/src/config/localization/lang_list.dart';
import 'package:gens/src/config/localization/locale_constant.dart';
import 'package:gens/src/config/sizes/short_text.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/fav_page/view/page/fav_page.dart';
import 'package:gens/src/feature/profile/controller/profile_controller.dart';
import 'package:gens/src/feature/profile/view/page/profile_row_container.dart';
import 'package:gens/src/feature/profile/view/widget/collection/profile_collection.dart';
import 'package:gens/src/feature/profile/view/widget/collection/profile_shimmer.dart';
import 'package:gens/src/feature/profile/view/widget/collection/skin_details.dart';
import 'package:gens/src/feature/profile/view/widget/collection/update_profile.dart';
import 'package:gens/src/feature/profile/view/widget/text/profile_text.dart';
import 'package:gens/src/feature/question/controller/add_image_user_controller.dart';
import 'package:gens/src/feature/question/controller/add_product_controller.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  final controller = Get.put(ProfileController());
  final imageController = Get.put(AddImageUserController());
  final productController = Get.put(AddProductController());

  User user = User();
  @override
  void initState() {
    initalState(context);
    super.initState();
  }

  Future<void> initalState(context) async {
    await user.loadToken();
    // controller.isSkinLoading.value == true;

    // controller.isUserLoading.value = true;

    await productController.getProduct();
    await controller.fetchSectionStatus();
    // await imageController.getUserthreeImage();
    // await controller.getUser(user.userId, context);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          color: const Color(0xfff5f5f5),
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.0.kH,
                  _buildHeaderButton(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Row(
                      children: [
                        controller.isUserLoading.value ||
                                controller.isLoadingImg.value == true
                            ? profileImageShimmer()
                            : _buildProfileImage(context),
                        20.0.kW,
                        controller.isUserLoading.value ||
                                controller.isLoadingImg.value == true
                            ? profileHeaderShimmer()
                            : _buildHeaderText(context),
                      ],
                    ),
                  ),
                  profileContainerRow(controller),
                  controller.isSkinLoading.value
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    width: context.screenWidth * .9,
                                    height: context.screenHeight * .1,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                            AppTheme.lightAppColors.background),
                                  ),
                                  20.0.kH,
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    width: context.screenWidth * .9,
                                    height: context.screenHeight * .1,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                            AppTheme.lightAppColors.background),
                                  ),
                                  20.0.kH,
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    width: context.screenWidth * .9,
                                    height: context.screenHeight * .1,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                            AppTheme.lightAppColors.background),
                                  ),
                                  20.0.kH,
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    width: context.screenWidth * .9,
                                    height: context.screenHeight * .1,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:
                                            AppTheme.lightAppColors.background),
                                  ),
                                ],
                              )),
                        )
                      : Container(
                          color: const Color(0xfff5f5f5),
                          width: context.screenWidth,
                          // padding: EdgeInsets.all(20),
                          child: Obx(() {
                            switch (controller.selectedIndex.value) {
                              case 0:
                                return SkinDetailsPage(
                                  gender: controller.userData.value!.gender,
                                  controller: controller,
                                );

                              default:
                                return Container();
                            }
                          }),
                        ),
                ],
              ),
            ),
          ),
        ));
  }

  SizedBox _buildHeaderText(BuildContext context) {
    return SizedBox(
      width: context.screenWidth * .45,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileText.mainText(nameShortText(
              "${controller.userData.value?.fName} ${controller.userData.value?.secName}")),
          5.0.kH,
          ProfileText.secText1(
              "+962${controller.removeLeadingZero(controller.userData.value!.phone)}"),
          5.0.kH,
          Row(
            children: [
              ProfileText.secText("Age".tr),
              ProfileText.secText(controller.dateOfBirth.text),
            ],
          ),
          controller.question.value?.mainSkincareGoals == '' ||
                  controller.question.value?.mainSkincareGoals == null
              ? const SizedBox.shrink()
              : SingleChildScrollView(
                  child: Get.locale!.languageCode == 'en'
                      ? Column(
                          children: [
                            SizedBox(
                              width: context.screenWidth * .46,
                              child: ProfileText.secText(
                                  "Skin goals : ${controller.question.value?.mainSkincareGoals}"),
                            )
                          ],
                        )
                      : Column(
                          children: [
                            SizedBox(
                              width: context.screenWidth * .46,
                              child: ProfileText.secText(
                                  "أهداف : ${controller.question.value?.mainSkincareGoals}"),
                            )
                          ],
                        ),
                )
        ],
      ),
    );
  }

  GestureDetector _buildProfileImage(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showPopupButtons(context, controller);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 150,
        height: 150,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: AppTheme.lightAppColors.background),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: AppTheme.lightAppColors.black.withOpacity(0.1),
          backgroundImage: controller.userData.value!.userImage == "" ||
                  controller.userData.value!.userImage == "string"
              ? const AssetImage(
                  "assets/image/profileIcon.png",
                )
              : NetworkImage(controller.userData.value!.userImage ?? ''),
        ),
      ),
    );
  }

  Padding _buildHeaderButton() {
    final localController = Get.put(LocalizationController());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          profileSitting(localController),
          10.0.kW,
          GestureDetector(
            onTap: () {
              Get.to(() => const FavPage());
            },
            child: Image.asset(
              "assets/image/lover.png",
              color: AppTheme.lightAppColors.secondaryColor,
              height: 25,
            ),
          ),
          10.0.kW,
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _buildLogoutDialog(context);
                },
              );
            },
            child: Image.asset(
              "assets/image/out.png",
              height: 25,
            ),
          ),
        ],
      ),
    );
  }

  AlertDialog _buildLogoutDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.lightAppColors.background,
      title: ProfileText.mainText("Confirmation".tr),
      content: ProfileText.secText("Are you sure you want to log out?".tr),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: ProfileText.mainText("Cancel".tr),
        ),
        SizedBox(
          width: context.screenWidth * .3,
          child: AppButton(
            onTap: () {
              Navigator.of(context).pop(); // Close the dialog
              controller.logout(context); // Call the logout function
            },
            title: "logout".tr,
          ),
        ),
      ],
    );
  }

  PopupMenuButton<int> profileSitting(LocalizationController localController) {
    return PopupMenuButton<int>(
      color: AppTheme.lightAppColors.background,
      icon: Image.asset(
        "assets/image/settings.png",
        height: 25,
      ),
      onSelected: (value) {
        if (value == 1) {
          Get.to(() => const UpdateProfile());
        } else if (value == 2) {
          // Add any other actions here
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Row(
            children: [
              const Icon(Icons.edit, color: Colors.black),
              8.0.kH,
              Text(
                "Edit Profile",
                style: TextStyle(color: AppTheme.lightAppColors.black),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            children: [
              const Icon(Icons.language, color: Colors.black),
              const SizedBox(width: 8),
              Text(
                "Edit Language",
                style: TextStyle(
                    color: AppTheme.lightAppColors.black, fontFamily: "Inter"),
              ),
            ],
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: AppTheme.lightAppColors.background,
                  title: Text("Select Language".tr),
                  content: Text("Choose a language for your Application.".tr),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        localController
                            .updateLanguage(Languages.locale[1]['locale']);

                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Arabic".tr,
                        style: TextStyle(color: AppTheme.lightAppColors.black),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        localController
                            .updateLanguage(Languages.locale[0]['locale']);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "English".tr,
                        style: TextStyle(color: AppTheme.lightAppColors.black),
                      ),
                    )
                  ],
                );
              },
            );
          },
        ),
      ],
    );
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
