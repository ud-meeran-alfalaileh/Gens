import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/short_text.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/dashboard/view/widget/text/dashboard_text.dart';
import 'package:gens/src/feature/doctor_profile/view/widget/text/doctor_text.dart';
import 'package:gens/src/feature/history/controller/history_controller.dart';
import 'package:gens/src/feature/history/model/user_waiting_model.dart';
import 'package:gens/src/feature/vendor_dashboard/view/widget/text/vendor_dashboard_text.dart';
import 'package:gens/src/feature/waiting_list/view/widget/text/waiting_list_text.dart';
import 'package:get/get.dart';

class UserWaitingListWidget extends StatefulWidget {
  const UserWaitingListWidget({super.key});

  @override
  State<UserWaitingListWidget> createState() => _UserWaitingListWidgetState();
}

class _UserWaitingListWidgetState extends State<UserWaitingListWidget> {
  final controller = Get.put(HistoryController());
  @override
  void initState() {
    controller.getWaitingList(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Obx(
        () => Column(
          children: [
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
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return _buildHistoryContainer(
                              controller.waitingList[index], context);
                        },
                        separatorBuilder: (context, index) {
                          return 20.0.kH;
                        },
                        itemCount: controller.waitingList.length),
                  )
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryContainer(UserWaitingList history, index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: context.screenWidth,
      decoration: BoxDecoration(
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
            children: [
              CircleAvatar(
                backgroundImage: history.vendorImages.isEmpty
                    ? const AssetImage("assets/image/AppLogo (1).png")
                    : NetworkImage(history.vendorImages.first),
                radius: 30,
              ),
              10.0.kW,
              SizedBox(
                width: context.screenWidth * .55,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DashboardText.mainText(history.vendorName),
                    7.0.kH,

                    // DashboardText.typeText(history.vemd),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 20,
                          color: AppTheme.lightAppColors.black.withOpacity(0.5),
                        ),
                        // 5.0.kW,
                        DashboardText.locationText(
                            locationShortText(history.vendorAddress)),
                      ],
                    ),
                    10.0.kH,
                  ],
                ),
              )
            ],
          ),
          const Divider(),
          Row(
            children: [
              WaitingListText.thirdText("Range Date".tr),
              const Spacer(),
              WaitingListText.thirdText(
                  "${history.startDate}\n${history.endDate}"),
            ],
          ),
          20.0.kH,
          Row(
            children: [
              WaitingListText.thirdText("Time Date".tr),
              const Spacer(),
              WaitingListText.thirdText(history.startTime.substring(0, 5)),
              WaitingListText.thirdText("To1".tr),
              WaitingListText.thirdText(history.endTime.substring(0, 5)),
            ],
          ),
          const Divider(),
          10.0.kH,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              WaitingListText.secText(history.status == "Accept"
                  ? "Accept".tr
                  : history.status == "Waiting"
                      ? "Waiting".tr
                      : "Reject".tr),
            ],
          )
        ],
      ),
    );
  }
}
