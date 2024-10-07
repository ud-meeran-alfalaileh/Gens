import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/short_text.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/user.dart';
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
    await imageController.getUserthreeImage();
    await controller.getUser(user.userId, context);

    await controller
        .getQuestionDetails()
        .whenComplete(() => controller.isSkinLoading.value == false);
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
      width: context.screenWidth * .46,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileText.mainText(nameShortText(
              "${controller.userData.value?.fName} ${controller.userData.value?.secName}")),
          5.0.kH,
          ProfileText.secText(
              "+962${controller.removeLeadingZero(controller.userData.value!.phone)}"),
          5.0.kH,
          ProfileText.secText("Age : ${controller.dateOfBirth.text}"),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: context.screenWidth * .46,
                  child: ProfileText.secText(
                      "Skin goals : ${controller.question.value?.mainSkincareGoals}"),
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
              ? const AssetImage("assets/image/profileIcon.png")
              : NetworkImage(controller.userData.value!.userImage ?? ''),
        ),
      ),
    );
  }

  Padding _buildHeaderButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(
            onTap: () {
              Get.to(() => const UpdateProfile());
            },
            child: Image.asset(
              "assets/image/settings.png",
              height: 25,
            ),
          ),
          10.0.kW,
          GestureDetector(
            onTap: () {
              Get.to(() => const FavPage());
            },
            child: Image.asset(
              "assets/image/lover.png",
              height: 25,
            ),
          ),
          10.0.kW,
          GestureDetector(
            onTap: () {
              controller.logout();
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
