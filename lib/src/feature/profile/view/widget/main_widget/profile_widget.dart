import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/core/utils/loading_page.dart';
import 'package:gens/src/feature/profile/controller/profile_controller.dart';
import 'package:gens/src/feature/profile/view/page/update_profile.dart';
import 'package:gens/src/feature/profile/view/widget/collection/profile_collection.dart';
import 'package:gens/src/feature/profile/view/widget/text/profile_text.dart';
import 'package:gens/src/feature/setting/view/page/setting_page.dart';
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
    return Obx(() => Stack(
          children: [
            controller.isLoading.value == true
                ? loadingPage(context)
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          (context.screenHeight * .06).kH,
                          GestureDetector(
                            onTap: () {
                              showPopupButtons(context, controller);
                            },
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
                          (context.screenHeight * .01).kH,
                          ProfileText.mainText(
                              "${controller.userData.value?.fName} ${controller.userData.value?.secName}"),
                          ProfileText.secText(
                              "+962${controller.removeLeadingZero(controller.userData.value!.phone)}"),
                          (context.screenHeight * .04).kH,
                          profileRow(
                              Icon(
                                Icons.person_outline,
                                color: AppTheme.lightAppColors.primary,
                              ),
                              "Edit Profile", () {
                            Get.to(() => const UpdateProfile());
                          }),
                          const Divider(),
                          profileRow(
                              Icon(
                                Icons.favorite_outline,
                                color: AppTheme.lightAppColors.primary,
                              ),
                              "Favorite",
                              () {}),
                          const Divider(),
                          profileRow(
                              Icon(
                                Icons.settings_outlined,
                                color: AppTheme.lightAppColors.primary,
                              ),
                              "Settings", () {
                            Get.to(() => const SettingPage());
                          }),
                          const Divider(),
                          // profileRow(
                          //     Icon(
                          //       Icons.help_center_outlined,
                          //       color: AppTheme.lightAppColors.primary,
                          //     ),
                          //     "Help and Support",
                          //     () {}),
                          // const Divider(),
                          profileRow(
                              Icon(
                                Icons.safety_check,
                                color: AppTheme.lightAppColors.primary,
                              ),
                              "Terms and Conditions",
                              () {}),
                          const Divider(),
                          profileRow(
                              Icon(
                                Icons.logout,
                                color: AppTheme.lightAppColors.primary,
                              ),
                              "Logout", () {
                            controller.logout();
                          }),
                        ],
                      ),
                    ),
                  ),
            controller.isLoadingImg.value
                ? loadingPage(context)
                : const SizedBox.shrink()
          ],
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
