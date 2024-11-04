import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/short_text.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/api/notification_controller.dart';
import 'package:gens/src/feature/booking/view/page/booking_page.dart';
import 'package:gens/src/feature/dashboard/view/widget/collection/dashboard_shimmer.dart';
import 'package:gens/src/feature/dashboard/view/widget/text/dashboard_text.dart';
import 'package:gens/src/feature/doctor_profile/controller/doctor_controller.dart';
import 'package:gens/src/feature/history/controller/history_controller.dart';
import 'package:gens/src/feature/history/model/history_model.dart';
import 'package:gens/src/feature/history/view/page/user_waiting_list.dart';
import 'package:gens/src/feature/history/view/widget/text/history_text.dart';
import 'package:gens/src/feature/test.dart';
import 'package:gens/src/feature/vendor_services/view/widget/text/services_text.dart';
import 'package:get/get.dart';

class HistoryWidget extends StatefulWidget {
  const HistoryWidget({super.key});

  @override
  State<HistoryWidget> createState() => _HistoryWidgetState();
}

class _HistoryWidgetState extends State<HistoryWidget> {
  final doctorController = Get.put(DoctorController());
  // Define the currently selected index

  // List of colors for unselected and selected text
  final List<Color> _colors = [
    AppTheme.lightAppColors.primary,
    AppTheme.lightAppColors.subTextcolor
  ];

  final controller = Get.put(HistoryController());
  @override
  void initState() {
    super.initState();
    controller.selectedIndex.value = 0; // Set default to Pending (index 0)
    getBooking(context);
  }

  Future<void> getBooking(context) async {
    await controller.user.loadToken();
    await controller.getBooking(context);
    controller.getFilteredList(0); // Filter the list for "Pending" by default
  }

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(HistoryController());
    return Stack(
      children: [
        SafeArea(
          child: SizedBox(
            width: context.screenWidth,
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    10.0.kH,
                    Row(
                      children: [
                        (context.screenWidth * .15).kW,
                        const Spacer(),
                        HistoryText.headerText("My Bookings".tr),
                        const Spacer(),
                        IconButton(
                          onPressed: () async {
                            controller.getWaitingList(context);
                            Get.to(() => const UserWaitingListPage());
                          },
                          icon: SizedBox(
                              height: context.screenHeight * .04,
                              width: context.screenWidth * .1,
                              child: RotatingImage()),
                        ),
                      ],
                    ),
                    (context.screenHeight * .03).kH,

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNavItem(0, 'Pending'.tr),
                        _buildNavItem(1, 'Upcoming'.tr),
                        _buildNavItem(2, 'DoneBooking'.tr),
                      ],
                    ),
                    // (context.screenHeight * .03).kH,
                    Obx(
                      () => controller.isLaoding.value
                          ? dashboardShimmer()
                          : controller.filteredList.isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    (context.screenHeight * .1).kH,
                                    Image.asset(
                                      "assets/image/no.png",
                                      width: context.screenWidth * .2,
                                      height: context.screenHeight * .1,
                                    ),
                                    20.0.kW,
                                    ServicesText.secText(
                                        "There Is No Available booking".tr),
                                  ],
                                )
                              : SizedBox(
                                  child: ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: controller.filteredList.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          showBookingDetails(
                                            context,
                                            controller.filteredList[index],
                                          );
                                        },
                                        child: _buildHistoryContainer(
                                            controller.filteredList[index],
                                            index),
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return 5.0.kH;
                                    },
                                  ),
                                ),
                    ),
                    90.0.kH,
                  ]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavItem(int index, String title) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GestureDetector(
            onTap: () {
              controller.selectedIndex.value = index;
              controller.getFilteredList(index);
            },
            child: Obx(
              () => Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: controller.selectedIndex.value == index
                          ? _colors[0]
                          : _colors[1],
                      fontSize: 16,
                      fontWeight: controller.selectedIndex.value == index
                          ? FontWeight.w800
                          : FontWeight.w600,
                    ),
                  ),
                  10.0.kH,
                  Container(
                    width: context.screenWidth * .2,
                    height: 2,
                    decoration: BoxDecoration(
                        color: controller.selectedIndex.value == index
                            ? AppTheme.lightAppColors.primary
                            : Colors.transparent,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(2))),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryContainer(History history, index) {
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
              Text(history.day),
              10.0.kW,
              Text(history.date),
              const Spacer(),
              DashboardText.locationText(
                  locationShortText("At ${history.time} "))
            ],
          ),
          const Divider(),
          Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: history.vendorImg.isEmpty
                          ? const AssetImage("assets/image/AppLogo (1).png")
                          : NetworkImage(history.vendorImg),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter),
                ),
              ),
              10.0.kW,
              SizedBox(
                width: 190,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DashboardText.mainText(history.vendorName),
                    7.0.kH,
                    Container(
                      width: context.screenWidth * .45,
                      decoration: BoxDecoration(
                          color: AppTheme.lightAppColors.subTextcolor,
                          border: Border.all(
                              color: AppTheme.lightAppColors.bordercolor,
                              width: .5)),
                    ),
                    7.0.kH,
                    DashboardText.typeText(history.vendorType),
                    10.0.kH,
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 20,
                          color: AppTheme.lightAppColors.black.withOpacity(0.5),
                        ),
                        // 5.0.kW,
                        DashboardText.locationText(
                            locationShortText(history.vendorLocation)),
                      ],
                    ),
                    10.0.kH,
                  ],
                ),
              )
            ],
          ),
          const Divider(),
          10.0.kH,
          history.status == "Done"
              ? const SizedBox.shrink()
              : GestureDetector(
                  onTap: () {
                    doctorController.srevice.value = history.serviceId;
                    Get.to(() => BookingPage(
                          vendorId: history.vendorId,
                          type: 'reschadule',
                          bookId: history.id,
                          vendorPhone: history.vendorPhone,
                        ));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: context.screenWidth * .4,
                        height: context.screenHeight * .05,
                        decoration: BoxDecoration(
                            color: AppTheme.lightAppColors.primary,
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text(
                            "Reschedule".tr,
                            style: TextStyle(
                                color: AppTheme.lightAppColors.background,
                                fontFamily: "Inter",
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor:
                                    AppTheme.lightAppColors.background,
                                title: Text(

                                    ///String
                                    "Are you sure you want to delete this reservation?"
                                        .tr),
                                actions: [
                                  TextButton(
                                    child: Text(
                                      "Cancel".tr,
                                      style: TextStyle(
                                          color:
                                              AppTheme.lightAppColors.primary),
                                    ),
                                    onPressed: () {
                                      Get.back();
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      "Yes".tr,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () async {
                                      ////Delete
                                      await controller.canceleBooking(
                                        history.id,
                                        index,
                                        NotificationModel(
                                            title: "Appointment Canceled",
                                            message:
                                                "The user has canceled their appointment. Please update your schedule accordingly.",
                                            imageURL: "imageURL",
                                            externalIds: history.vendorPhone),
                                      );
                                      Get.back();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          width: context.screenWidth * .4,
                          height: context.screenHeight * .05,
                          decoration: BoxDecoration(
                              color: AppTheme.lightAppColors.maincolor,
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              "Cancel".tr,
                              style: TextStyle(
                                  color: AppTheme.lightAppColors.primary,
                                  fontFamily: "Inter",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }

  Future<dynamic> showBookingDetails(
    BuildContext context,
    History history,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.lightAppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(13),
          content: SizedBox(
            width: context.screenWidth * 0.9,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(history.vendorImg),
                    ),
                    10.0.kW,
                    SizedBox(
                      width: context.screenWidth * .5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HistoryText.secText(history.vendorName),
                          HistoryText.thirdText(history.date),
                        ],
                      ),
                    )
                  ],
                ),
                const Divider(),
                HistoryText.secText(history.serviceName),
                HistoryText.thirdText("At ${history.time}"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Start from: ${history.servicePrice.toString()}JD")
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
