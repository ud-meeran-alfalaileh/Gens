import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/doctor_profile/view/widget/text/doctor_text.dart';
import 'package:gens/src/feature/show_user/view/page/show_user_page.dart';
import 'package:gens/src/feature/vendor_dashboard/controller/vendor_dashboard_controoler.dart';
import 'package:gens/src/feature/vendor_dashboard/view/widget/text/vendor_dashboard_text.dart';
import 'package:gens/src/feature/waiting_list/model/waiting_list_model.dart';
import 'package:gens/src/feature/waiting_list/view/widget/text/waiting_list_text.dart';
import 'package:get/get.dart';

class VendorWaitingListWidget extends StatefulWidget {
  const VendorWaitingListWidget({super.key});

  @override
  State<VendorWaitingListWidget> createState() =>
      _VendorWaitingListWidgetState();
}

class _VendorWaitingListWidgetState extends State<VendorWaitingListWidget> {
  final controller = Get.put(VendorDashboardController());

  @override
  void initState() {
    super.initState();
    controller.getWaitingList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          20.0.kH,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: AppTheme.lightAppColors.black.withOpacity(.8),
                  )),
              const Spacer(),
              DoctorText.mainText("Waiting list".tr),
              const Spacer(),
              (30.0).kW,
            ],
          ),
          controller.waitingList.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    100.0.kH,
                    Image.asset(
                      'assets/image/empty-box.png',
                      width: 200,
                    ),
                    10.0.kH,
                    VendorDashboardText.emptyText(
                        "Currently, there are no bookings available for you"
                            .tr),
                  ],
                )
              : Expanded(
                  child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return _buildWaitingListContainer(
                            context, controller, index);
                      },
                      separatorBuilder: (context, index) {
                        return 10.0.kH;
                      },
                      itemCount: controller.waitingList.length),
                ),
          // 20.0.kH,
        ],
      ),
    );
  }

  _buildWaitingListContainer(
      BuildContext context, VendorDashboardController controller, int index) {
    RxBool statusUpadating = false.obs;
    return GestureDetector(
      onTap: () {
        Get.to(() => ShowUserPage(
              id: controller.waitingList[index].userId,
            ));
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.all(10),
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
          children: [
            Row(
              children: [
                WaitingListText.mainText(
                    controller.waitingList[index].userName),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      controller.makePhoneCall(
                          controller.waitingList[index].userPhoneNumber);
                    },
                    icon: Icon(
                      Icons.phone,
                      color: AppTheme.lightAppColors.primary,
                    )),
              ],
            ),
            const Divider(),
            Row(
              children: [
                WaitingListText.thirdText("Range Date".tr),
                const Spacer(),
                WaitingListText.thirdText(
                    controller.waitingList[index].startDate +
                        "\n" +
                        controller.waitingList[index].endDate),
              ],
            ),
            10.0.kH,
            Row(
              children: [
                WaitingListText.thirdText("Time Date".tr),
                const Spacer(),
                WaitingListText.thirdText(
                    controller.waitingList[index].startTime.substring(0, 5)),
                WaitingListText.thirdText("To1".tr),
                Text(controller.waitingList[index].endTime.substring(0, 5)),
              ],
            ),
            10.0.kH,
            Obx(
              () => statusUpadating.value
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.lightAppColors.primary,
                        ),
                      ),
                    )
                  : controller.waitingList[index].status == "Accept"
                      ? Text('Done'.tr)
                      : controller.waitingList[index].status == "Reject"
                          ? Text('Reject'.tr)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                statusWidget(
                                  controller.waitingList[index],
                                  statusUpadating,
                                  context,
                                  'Accept',
                                  'Accept'.tr,
                                  controller.waitingList[index].userPhoneNumber,
                                  controller,
                                ),
                                10.0.kW,
                                statusWidget(
                                    controller.waitingList[index],
                                    statusUpadating,
                                    context,
                                    'Reject',
                                    'Reject'.tr,
                                    controller
                                        .waitingList[index].userPhoneNumber,
                                    controller)
                              ],
                            ),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector statusWidget(
      WaitingListModel model,
      RxBool statusUpadating,
      BuildContext context,
      status,
      title,
      userPhone,
      VendorDashboardController controller) {
    return GestureDetector(
      onTap: () {
        controller.updateWaitingStatus(
            status, model.id, model, statusUpadating, userPhone);
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
}
