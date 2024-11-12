import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/dashboard/model/dashboard_filter_model.dart';
import 'package:gens/src/feature/dashboard/view/widget/collection/profile_containers.dart';
import 'package:gens/src/feature/history/model/history_model.dart';
import 'package:gens/src/feature/login/model/login_form_model.dart';
import 'package:gens/src/feature/show_user/view/page/show_user_page.dart';
import 'package:gens/src/feature/vendor_dashboard/controller/vendor_dashboard_controoler.dart';
import 'package:gens/src/feature/vendor_dashboard/view/widget/collection/note_form.dart';
import 'package:gens/src/feature/vendor_dashboard/view/widget/text/vendor_dashboard_text.dart';
import 'package:get/get.dart';

final vendorGController = Get.put(VendorDashboardController());

Container vendorHeader(BuildContext context, waitingListLength) {
  return Container(
    // width: context.screenWidth * 0.99,
    // padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: AppTheme.lightAppColors.background,
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0),
          child: Row(
            children: [
              Image.asset(
                "assets/image/Logo2 2.png",
                height: 50,
                width: 100,
                fit: BoxFit.fitWidth,
              ),
              const Spacer(),
              // Stack(
              //   children: [
              //     IconButton(
              //         onPressed: () {
              //           Get.to(() => const VendorWaitingList());
              //         },
              //         icon: Icon(
              //           Icons.calendar_month_outlined,
              //           size: 30,
              //           color: AppTheme.lightAppColors.primary,
              //         )),
              //     Align(
              //       alignment: Alignment.topLeft,
              //       child: Container(
              //         width: context.screenWidth * .045,
              //         height: context.screenHeight * .03,
              //         decoration: const BoxDecoration(
              //             color: Colors.red, shape: BoxShape.circle),
              //         child: Center(
              //           child: Text(
              //             waitingListLength.toString(),
              //             style: TextStyle(
              //                 color: AppTheme.lightAppColors.background,
              //                 fontWeight: FontWeight.w700),
              //           ),
              //         ),
              //       ),
              //     )
              //   ],
              // )
            ],
          ),
        ),
        const Divider()
      ],
    ),
  );
}

vendorBookingContainerToday(BuildContext context, index, VendorBooking model,
    VendorDashboardController controller) {
  RxBool statusUpadating = false.obs;

  return Obx(
    () => GestureDetector(
      onTap: () {
        Get.to(() => ShowUserPage(
              id: model.userId,
            ));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: context.screenWidth,
        decoration: BoxDecoration(
            border: Border.all(color: AppTheme.lightAppColors.maincolor),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightAppColors.black.withOpacity(0.1),
                spreadRadius: 1.5,
                blurRadius: 10,
                offset: const Offset(0, 1),
              ),
            ],
            color: AppTheme.lightAppColors.background),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.lightAppColors.maincolor,
                  radius: 30,
                  backgroundImage: model.userImage == ""
                      ? const AssetImage("assets/image/profileIcon.png")
                      : NetworkImage(model.userImage),
                ),
                10.0.kW,
                VendorDashboardText.secText(model.userName),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      vendorGController.makePhoneCall(model.userPhoneNumber);
                    },
                    icon: Icon(
                      Icons.phone,
                      color: AppTheme.lightAppColors.primary,
                    )),
              ],
            ),
            Divider(
              color: AppTheme.lightAppColors.maincolor,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  VendorDashboardText.thirdText(model.serviceTitle),
                  10.0.kH,
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        color: AppTheme.lightAppColors.primary,
                        size: 16,
                      ),
                      VendorDashboardText.timeText(model.date),
                    ],
                  ),
                  3.0.kH,
                  VendorDashboardText.timeText(
                      "From ${model.startTime} to ${model.endTime}")
                ],
              ),
              statusUpadating.value
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.lightAppColors.primary,
                        ),
                      ),
                    )
                  : model.status == "Pending"
                      ? Column(
                          children: [
                            statusWidget(model, statusUpadating, context,
                                "Upcoming", 'Accept'.tr),
                            10.0.kH,
                            statusWidgetReject(model, statusUpadating, context,
                                "Rejected", 'Reject'.tr),
                          ],
                        )
                      : model.status == "Upcoming"
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                statusWidgetToday(
                                  model,
                                  statusUpadating,
                                  context,
                                  "Done",
                                  "Done".tr,
                                  index,
                                ),
                                5.0.kH,
                                statusWidgetToday(
                                  model,
                                  statusUpadating,
                                  context,
                                  "Absent",
                                  "Absent".tr,
                                  index,
                                ),
                              ],
                            )
                          : const Text("Done")
            ]),
            model.showNote
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.0.kH,
                      VendorDashboardText.thirdText("Note"),
                      7.0.kH,
                      NoteForm(
                        formModel: FormModel(
                            controller: controller.noteMessage,
                            enableText: false,
                            hintText: "Add Note..",
                            invisible: false,
                            validator: null,
                            type: TextInputType.text,
                            inputFormat: [],
                            onTap: () {}),
                      ),
                      10.0.kH,
                      AppButton(
                          onTap: () {
                            controller.addNote(
                                model, controller.noteMessage.text.trim());
                          },
                          title: "Submit".tr)
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.0.kH,
                      model.note == ""
                          ? const SizedBox.shrink()
                          : VendorDashboardText.thirdText("Note"),
                      VendorDashboardText.timeText(model.note)
                    ],
                  )
          ],
        ),
      ),
    ),
  );
}

GestureDetector statusWidgetToday(
  VendorBooking model,
  RxBool statusUpadating,
  BuildContext context,
  String status,
  String title,
  int index,
  // Pass showNote as a parameter
) {
  return GestureDetector(
    onTap: () async {
      model.status == "Pending"
          ? pendingDialog(context, model, statusUpadating)
          : await vendorGController.updateBookingStatus('$status', model.id,
              model, statusUpadating, true, model.userPhoneNumber);

      if (status == "Absent" || status == "Done") {
        vendorGController.filteredBooking.remove(model);
      }
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: context.screenHeight * .04,
      decoration: BoxDecoration(
        color: model.status == "Done"
            ? Colors.green
            : title == "Didn't show"
                ? Colors.red
                : AppTheme.lightAppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: AppTheme.lightAppColors.background,
            fontFamily: 'Inter',
          ),
        ),
      ),
    ),
  );
}

vendorBookingContainer(BuildContext context, index, VendorBooking model) {
  RxBool statusUpadating = false.obs;

  return Obx(
    () => GestureDetector(
      onTap: () {
        Get.to(() => ShowUserPage(
              id: model.userId,
            ));
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        width: context.screenWidth,
        decoration: BoxDecoration(
            border: Border.all(color: AppTheme.lightAppColors.maincolor),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightAppColors.black.withOpacity(0.1),
                spreadRadius: 1.5,
                blurRadius: 10,
                offset: const Offset(0, 1),
              ),
            ],
            color: AppTheme.lightAppColors.background),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.lightAppColors.maincolor,
                  radius: 30,
                  backgroundImage: model.userImage == ""
                      ? const AssetImage("assets/image/profileIcon.png")
                      : NetworkImage(model.userImage),
                ),
                10.0.kW,
                VendorDashboardText.secText(model.userName),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      vendorGController.makePhoneCall(model.userPhoneNumber);
                    },
                    icon: Icon(
                      Icons.phone,
                      color: AppTheme.lightAppColors.primary,
                    )),
              ],
            ),
            Divider(
              color: AppTheme.lightAppColors.maincolor,
            ),
            VendorDashboardText.thirdText(model.serviceTitle),
            5.0.kH,
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        color: AppTheme.lightAppColors.primary,
                        size: 16,
                      ),
                      VendorDashboardText.timeText(model.date),
                    ],
                  ),
                  3.0.kH,
                  VendorDashboardText.timeText(
                      "From ${model.startTime} to ${model.endTime}")
                ],
              ),
              statusUpadating.value
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.lightAppColors.primary,
                        ),
                      ),
                    )
                  : model.status == "Pending"
                      ? Column(
                          children: [
                            statusWidget(model, statusUpadating, context,
                                "Upcoming", 'Accept'.tr),
                            10.0.kH,
                            statusWidgetReject(model, statusUpadating, context,
                                "Rejected", 'Reject'.tr),
                          ],
                        )
                      : model.status == "Upcoming"
                          ? statusWidget(model, statusUpadating, context,
                              "Waiting", 'Waiting'.tr)
                          : Text(model.status),
            ]),
            16.0.kH,
          ],
        ),
      ),
    ),
  );
}

GestureDetector statusWidget(VendorBooking model, RxBool statusUpadating,
    BuildContext context, status, title) {
  return GestureDetector(
    onTap: () {
      model.status == "Pending"
          ? pendingDialog(context, model, statusUpadating)
          : status == 'Waiting'
              ? null
              : vendorGController.updateBookingStatus('$status', model.id,
                  model, statusUpadating, true, model.userPhoneNumber);
      // model.status = "Upcoming";
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: context.screenHeight * .04,
      decoration: BoxDecoration(
          color: model.status == "Done"
              ? Colors.green
              : status == "Waiting"
                  ? AppTheme.lightAppColors.bordercolor
                  : AppTheme.lightAppColors.primary,
          borderRadius: BorderRadius.circular(20)),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: AppTheme.lightAppColors.background,
            fontFamily: 'Inter',
          ),
        ),
      ),
    ),
  );
}

GestureDetector statusWidgetReject(VendorBooking model, RxBool statusUpadating,
    BuildContext context, status, title) {
  return GestureDetector(
    onTap: () {
      vendorGController.updateBookingStatus('$status', model.id, model,
          statusUpadating, true, model.userPhoneNumber);
      // model.status = "Upcoming";
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: context.screenHeight * .04,
      decoration: BoxDecoration(
          color: AppTheme.lightAppColors.secondaryColor,
          borderRadius: BorderRadius.circular(20)),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: AppTheme.lightAppColors.background,
            fontFamily: 'Inter',
          ),
        ),
      ),
    ),
  );
}

vendorDashboardContainerRow(VendorDashboardController controller) {
  return Container(
    // color: AppTheme,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardContainer(
              model: DashboardFilterModel(
                  onTap: () {
                    controller.filterBooking("");

                    controller.setSelectedIndex(0);
                    controller.setPageIndex(0);
                  },
                  isSelected: controller.selectedIndex.value == 0,
                  title: "All".tr),
            ),
            20.0.kW,
            DashboardContainer(
              model: DashboardFilterModel(
                  onTap: () {
                    controller.filterBooking("Today");
                    controller.setSelectedIndex(1);
                    controller.setPageIndex(0);
                  },
                  isSelected: controller.selectedIndex.value == 1,
                  title: "Today".tr),
            ),
            20.0.kW,
            DashboardContainer(
              model: DashboardFilterModel(
                  onTap: () {
                    controller.filterBooking("Pending");
                    controller.setSelectedIndex(2);
                    controller.setPageIndex(0);
                  },
                  isSelected: controller.selectedIndex.value == 2,
                  title: "Waiting".tr),
            ),
            20.0.kW,
            DashboardContainer(
              model: DashboardFilterModel(
                  onTap: () {
                    controller.filterBooking("Upcoming");
                    controller.setPageIndex(0);
                    controller.setSelectedIndex(3);
                  },
                  isSelected: controller.selectedIndex.value == 3,
                  title: "Upcoming".tr),
            ),
            20.0.kW,
            DashboardContainer(
              model: DashboardFilterModel(
                  onTap: () {
                    controller.setSelectedIndex(4);

                    controller.setPageIndex(1);
                  },
                  isSelected: controller.selectedIndex.value == 4,
                  title: "Done".tr),
            ),
            20.0.kW,
            20.0.kW,
            20.0.kW,
          ],
        ),
      ),
    ),
  );
}

Future<dynamic> pendingDialog(BuildContext context, model, statusUpadating) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppTheme.lightAppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: const EdgeInsets.all(10),
        content: SizedBox(
          width: context.screenWidth * 0.6,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Do you want to remove the time from the schedule'.tr,
                style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 16,
                    color: AppTheme.lightAppColors.black),
              ),
              20.0.kH,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: context.screenWidth * .2,
                    child: AppButton(
                        onTap: () async {
                          Get.back();
                          await vendorGController.updateBookingStatus(
                              'Upcoming',
                              model.id,
                              model,
                              statusUpadating,
                              true,
                              model.userPhoneNumber);
                        },
                        title: "Yes".tr),
                  ),
                  TextButton(
                      onPressed: () async {
                        Get.back();
                        await vendorGController.updateBookingStatus(
                            'Upcoming',
                            model.id,
                            model,
                            statusUpadating,
                            false,
                            model.userPhoneNumber);
                      },
                      child: Text(
                        "No".tr,
                        style:
                            TextStyle(color: AppTheme.lightAppColors.primary),
                      )),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
