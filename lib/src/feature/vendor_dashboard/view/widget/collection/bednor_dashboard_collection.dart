import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/dashboard/model/dashboard_filter_model.dart';
import 'package:gens/src/feature/dashboard/view/widget/collection/profile_containers.dart';
import 'package:gens/src/feature/history/model/history_model.dart';
import 'package:gens/src/feature/show_user/view/page/show_user_page.dart';
import 'package:gens/src/feature/vendor_dashboard/controller/vendor_dashboard_controoler.dart';
import 'package:gens/src/feature/vendor_dashboard/view/widget/text/vendor_dashboard_text.dart';
import 'package:get/get.dart';

final vendorGController = Get.put(VendorDashboardController());

Container vendorHeader(BuildContext context) {
  return Container(
    width: context.screenWidth,
    height: context.screenHeight * .08,
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
                "assets/image/headerLogo.png",
                height: 30,
                width: 30,
                fit: BoxFit.cover,
              ),
              10.0.kW,
              Image.asset(
                "assets/image/Logo2 2.png",
                height: 40,
                width: 80,
                fit: BoxFit.fitWidth,
              )
            ],
          ),
        ),
        const Divider()
      ],
    ),
  );
}

vendorBookingContainerToday(BuildContext context, index, VendorBooking model) {
  RxBool statusUpadating = false.obs;

  return Obx(
    () => Container(
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
                    ? statusWidgetToday(
                        model, statusUpadating, context, "Upcoming", "Accept")
                    : model.status == "Upcoming"
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              statusWidgetToday(model, statusUpadating, context,
                                  "Done", "Done"),
                              5.0.kH,
                              statusWidgetToday(model, statusUpadating, context,
                                  "Didn'tShow", "Absent"),
                            ],
                          )
                        : const Text("remove this from here")
          ])
        ],
      ),
    ),
  );
}

GestureDetector statusWidgetToday(VendorBooking model, RxBool statusUpadating,
    BuildContext context, status, title) {
  return GestureDetector(
    onTap: () {
      print(status);
      vendorGController.updateBookingStatus(
          '$status', model.id, model, statusUpadating);
      // model.status = "Upcoming";
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
                      ? statusWidget(
                          model, statusUpadating, context, "Upcoming", 'Accept')
                      : model.status == "Upcoming"
                          ? statusWidget(model, statusUpadating, context,
                              "Waiting", 'Waiting')
                          : Text(model.status)
            ])
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
      status == 'Waiting'
          ? null
          : vendorGController.updateBookingStatus(
              '$status', model.id, model, statusUpadating);
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

SingleChildScrollView vendorDashboardContainerRow(
    VendorDashboardController controller) {
  return SingleChildScrollView(
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
                },
                isSelected: controller.selectedIndex.value == 0,
                title: "All"),
          ),
          20.0.kW,
          DashboardContainer(
            model: DashboardFilterModel(
                onTap: () {
                  controller.filterBooking("Today");
                  controller.setSelectedIndex(1);
                },
                isSelected: controller.selectedIndex.value == 1,
                title: "Today"),
          ),
          20.0.kW,
          DashboardContainer(
            model: DashboardFilterModel(
                onTap: () {
                  controller.filterBooking("Pending");
                  controller.setSelectedIndex(2);
                },
                isSelected: controller.selectedIndex.value == 2,
                title: "Waiting"),
          ),
          20.0.kW,
          DashboardContainer(
            model: DashboardFilterModel(
                onTap: () {
                  controller.filterBooking("Upcoming");

                  controller.setSelectedIndex(3);
                },
                isSelected: controller.selectedIndex.value == 3,
                title: "Upcoming"),
          ),
          20.0.kW,
          DashboardContainer(
            model: DashboardFilterModel(
                onTap: () {
                  controller.filterBooking("Done");

                  controller.setSelectedIndex(4);
                },
                isSelected: controller.selectedIndex.value == 4,
                title: "Done"),
          ),
          20.0.kW,
          20.0.kW,
        ],
      ),
    ),
  );
}
