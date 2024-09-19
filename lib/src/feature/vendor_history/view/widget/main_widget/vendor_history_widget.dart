import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/loading_page.dart';
import 'package:gens/src/feature/history/model/history_model.dart';
import 'package:gens/src/feature/profile/view/widget/text/profile_text.dart';
import 'package:gens/src/feature/vendor_dashboard/view/widget/collection/bednor_dashboard_collection.dart';
import 'package:gens/src/feature/vendor_dashboard/view/widget/text/vendor_dashboard_text.dart';
import 'package:gens/src/feature/vendor_history/controller/vendor_history_controller.dart';
import 'package:get/get.dart';

class VendorHistoryWidget extends StatelessWidget {
  const VendorHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VendorHistoryController());
    return Obx(
      () => SingleChildScrollView(
        child: controller.isLaoding.value
            ? loadingPage(context)
            : Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: AppTheme.lightAppColors.primary,
                          )),
                      const Spacer(),
                      ProfileText.mainText("History"),
                      const Spacer(),
                      40.0.kW
                    ],
                  ),
                  30.0.kH,
                  SizedBox(
                    child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return vendorBookingContainer(
                            context,
                            index,
                            controller.history[index],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return 15.0.kH;
                        },
                        itemCount: controller.history.length),
                  ),
                ],
              ),
      ),
    );
  }

  vendorBookingContainer(BuildContext context, index, VendorBooking model) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: context.screenWidth,
      height: context.screenHeight * .2,
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
          ])
        ],
      ),
    );
  }
}
