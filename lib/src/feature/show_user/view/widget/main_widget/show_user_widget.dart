import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/short_text.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/loading_page.dart';
import 'package:gens/src/feature/profile/view/widget/text/profile_text.dart';
import 'package:gens/src/feature/show_user/controller/show_user_controller.dart';
import 'package:gens/src/feature/show_user/view/widget/collection/show_user_skin.dart';
import 'package:gens/src/feature/show_user/view/widget/text/show_user_text.dart';
import 'package:get/get.dart';

class ShowUserWidget extends StatefulWidget {
  const ShowUserWidget({super.key, required this.id});
  final int id;

  @override
  State<ShowUserWidget> createState() => _ShowUserWidgetState();
}

class _ShowUserWidgetState extends State<ShowUserWidget> {
  final controller = Get.put(ShowUserController());
  @override
  void initState() {
    initmethod();
    super.initState();
  }

  Future<void> initmethod() async {
    await controller.getUser(widget.id);
    await controller.getProduct(widget.id);
    await controller.getQuestionDetails(widget.id);
    await controller.getUserthreeImage(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Obx(
        () => controller.isLoading.value
            ? loadingPage(context)
            : Obx(
                () => SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_new,
                                color: AppTheme.lightAppColors.primary,
                              )),
                        ],
                      ),
                      10.0.kH,
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor:
                                AppTheme.lightAppColors.black.withOpacity(0.1),
                            backgroundImage: controller
                                            .userData.value!.userImage ==
                                        "" ||
                                    controller.userData.value!.userImage ==
                                        "string"
                                ? const AssetImage(
                                    "assets/image/profileIcon.png")
                                : NetworkImage(
                                    controller.userData.value!.userImage ?? ''),
                          ),
                          20.0.kW,
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ShowUserText.mainText(nameShortText(
                                  "${controller.userData.value!.fName} ${controller.userData.value!.secName}")),
                              ProfileText.secText(
                                  controller.userData.value!.phone),
                              ProfileText.secText(
                                  "Age: ${controller.calculatedAge.toString()}"),
                            ],
                          )
                        ],
                      ),
                      ShowUserSkin(
                        gender: controller.userData.value!.gender,
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
