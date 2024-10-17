import 'package:flutter/material.dart';
import 'package:gens/src/config/localization/lang_list.dart';
import 'package:gens/src/config/localization/locale_constant.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/setting/controller/setting_controller.dart';
import 'package:gens/src/feature/setting/view/widget/text/setting_text.dart';
import 'package:get/get.dart';

class SittingWidget extends StatefulWidget {
  const SittingWidget({super.key});

  @override
  State<SittingWidget> createState() => _SittingWidgetState();
}

class _SittingWidgetState extends State<SittingWidget> {
  late SettingController controller;

  @override
  void initState() {
    controller = Get.put(SettingController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final localController = Get.put(LocalizationController());

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Row(
            children: [
              Text('appLanguage'.tr),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  controller.setLanguage('ar');
                  localController.updateLanguage(Languages.locale[1]['locale']);
                },
                child: Container(
                  width: context.screenWidth * .23,
                  height: context.screenHeight * .045,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppTheme.lightAppColors.thirdTextcolor),
                      color: controller.isArabic.value
                          ? AppTheme.lightAppColors.thirdTextcolor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                      child: SettingText.settingbuttonText(
                          "عربي",
                          controller.isArabic.value
                              ? AppTheme.lightAppColors.background
                              : AppTheme.lightAppColors.thirdTextcolor)),
                ),
              ),
              10.0.kW,
              GestureDetector(
                onTap: () {
                  controller.setLanguage('English');
                  localController.updateLanguage(Languages.locale[0]['locale']);
                },
                child: Container(
                  width: context.screenWidth * .23,
                  height: context.screenHeight * .045,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppTheme.lightAppColors.thirdTextcolor),
                      color: !controller.isArabic.value
                          ? AppTheme.lightAppColors.thirdTextcolor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                      child: SettingText.settingbuttonText(
                          "English",
                          !controller.isArabic.value
                              ? AppTheme.lightAppColors.background
                              : AppTheme.lightAppColors.thirdTextcolor)),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
