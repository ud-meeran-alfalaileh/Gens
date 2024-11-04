import 'package:flutter/material.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/profile/controller/profile_controller.dart';
import 'package:gens/src/feature/profile/view/widget/text/profile_text.dart';
import 'package:gens/src/feature/question/view/page/question_page.dart';
import 'package:get/get.dart';

class ProfileContainers extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isSelected;

  const ProfileContainers(
      {super.key,
      required this.onTap,
      required this.isSelected,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected
              ? AppTheme.lightAppColors.background
              : const Color(0xfff5f5f5),
        ),
        child: ProfileText.containerText(title, isSelected),
      ),
    );
  }
}

profileContainerRow(ProfileController controller) {
  return Obx(
    () => Row(
      children: [
        ProfileContainers(
          onTap: () {
            controller.setSelectedIndex(0);
          },
          isSelected: controller.selectedIndex.value == 0,
          title: "Skin Details".tr,
        ),
        const Spacer(),
        IconButton(
            onPressed: () {
              Get.to(() => QuestionPage(
                    gender: controller.userData.value!.gender,
                    type: 'notEmpty',
                  ));
            },
            icon: Icon(
              Icons.edit_note_outlined,
              color: AppTheme.lightAppColors.primary,
              size: 30,
            )),
        // ProfileContainers(
        //   onTap: () {
        //     controller.setSelectedIndex(1);
        //   },
        //   isSelected: controller.selectedIndex.value == 1,
        //   title: 'Profile Details'.tr,
        // ),
        // ProfileContainers(
        //   onTap: () {
        //     controller.logout();
        //   },
        //   isSelected: controller.selectedIndex.value == 3,
        //   title: 'logout'.tr,
        // ),
      ],
    ),
  );
}
