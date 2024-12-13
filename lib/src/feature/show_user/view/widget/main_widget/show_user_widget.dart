import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/short_text.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
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
    await controller.getNotes(widget.id);
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
                              Row(
                                children: [
                                  ProfileText.secText("Age".tr),
                                  ProfileText.secText(controller
                                      .calculatedAge.value
                                      .toString()),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      30.0.kH,
                      controller.notes.isEmpty
                          ? const SizedBox.shrink()
                          : Row(
                              children: [
                                SizedBox(
                                  width: context.screenWidth * .8,
                                  child: ShowUserText.mainText(
                                      "Notes from the previous Sessions"),
                                )
                              ],
                            ),
                      10.0.kH,
                      controller.notes.isEmpty
                          ? const SizedBox.shrink()
                          : ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: controller.notes.length,
                              separatorBuilder:
                                  (BuildContext context, int index) {
                                if (controller.notes[index].note == 'empty') {
                                  return const SizedBox.shrink();
                                } else {
                                  return 20.0.kH;
                                }
                              },
                              itemBuilder: (BuildContext context, int index) {
                                if (controller.notes[index].note == 'empty') {
                                  return const SizedBox.shrink();
                                } else {
                                  return Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppTheme
                                            .lightAppColors.secondaryColor
                                            .withOpacity(0.3),
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ShowUserText.secText(controller
                                                .notes[index].serviceTitle),
                                            ShowUserText.dateText(
                                                controller.notes[index].date),
                                          ],
                                        ),
                                        10.0.kH,
                                        ShowUserText.noteText(
                                            controller.notes[index].note!),
                                      ],
                                    ),
                                  );
                                }
                              },
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
