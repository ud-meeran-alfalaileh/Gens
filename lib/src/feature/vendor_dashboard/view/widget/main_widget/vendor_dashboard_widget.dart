import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/dashboard/view/widget/collection/dashboard_shimmer.dart';
import 'package:gens/src/feature/test.dart';
import 'package:gens/src/feature/vendor_calendar/controller/vendor_calendar_controller.dart';
import 'package:gens/src/feature/vendor_dashboard/controller/vendor_dashboard_controoler.dart';
import 'package:gens/src/feature/vendor_dashboard/view/widget/collection/bednor_dashboard_collection.dart';
import 'package:gens/src/feature/vendor_dashboard/view/widget/text/vendor_dashboard_text.dart';
import 'package:gens/src/feature/vendor_profile/controller/vendor_profile_controller.dart';
import 'package:gens/src/feature/vendor_services/view/widget/text/services_text.dart';
import 'package:gens/src/feature/waiting_list/view/page/vendor_waiting_list.dart';
import 'package:get/get.dart';

class VendorDashboardWidget extends StatefulWidget {
  const VendorDashboardWidget({super.key});

  @override
  State<VendorDashboardWidget> createState() => _VendorDashboardWidgetState();
}

class _VendorDashboardWidgetState extends State<VendorDashboardWidget> {
  final controller = Get.put(VendorDashboardController());
  final vendorController = Get.put(VendorProfileController());
  final navbarController = Get.put(VendorCalendarController());

  @override
  void initState() {
    _loadData();

    super.initState();
  }

  // Function to load data
  Future<void> _loadData() async {
    // controller.allVendorBooking.clear();
    // controller.todayVendorBooking.clear();

    controller.setSelectedIndex(0);
    controller.setPageIndex(0);
    controller.getVendorBoooking();
    // navbarController.getCalenderForVendor();
    // controller.getFormattedTodayDate();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        color: AppTheme.lightAppColors.primary,
        backgroundColor: AppTheme.lightAppColors.background,
        onRefresh: _loadData,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => _buildVendorHeader(context)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: vendorDashboardContainerRow(controller)),
              ),
              Obx(() => IndexedStack(
                    index: controller.currentPageIndex.value,
                    children: [
                      _pageOne(context),
                      _pageTodya(context),
                      _pagePending(context),
                      _pageWaiting(context),
                      _pageDone(context),
                      _pagePending(context),

                      // const VendorDoneWidget(),
                    ],
                  )),
              80.0.kH
            ],
          ),
        ),
      ),
    );
  }

  Obx _pageOne(BuildContext context) {
    return Obx(
      () => controller.isLaoding.value
          ? dashboardShimmer()
          : controller.allVendorBooking.isEmpty
              ? Center(
                  child: Column(
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
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: VendorDashboardText.mainText("Today Booking".tr),
                      ),
                      controller.todayVendorBooking.isNotEmpty
                          ? ListView.separated(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return vendorBookingContainerToday(
                                    context,
                                    index,
                                    controller.todayVendorBooking[index],
                                    controller);
                              },
                              separatorBuilder: (context, index) {
                                return 15.0.kH;
                              },
                              itemCount: controller.todayVendorBooking.length,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  color: AppTheme.lightAppColors.primary,
                                  size: 70,
                                ),
                                20.0.kW,
                                ServicesText.secText(
                                    "there is no booking for today".tr),
                              ],
                            ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child:
                            VendorDashboardText.mainText("Upcoming Booking".tr),
                      ),
                      20.0.kH,
                      controller.vendorBooking.isNotEmpty
                          ? ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return vendorBookingContainer(
                                  context,
                                  index,
                                  controller.vendorBooking[index],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return 15.0.kH;
                              },
                              itemCount: controller.vendorBooking.length,
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  color: AppTheme.lightAppColors.primary,
                                  size: 70,
                                ),
                                20.0.kW,
                                VendorDashboardText.emptyText(
                                    "Currently, there are no bookings available for you"
                                        .tr),
                              ],
                            ),
                    ],
                  ),
                ),
    );
  }

  Obx _pagePending(BuildContext context) {
    return Obx(
      () => controller.isLaoding.value
          ? dashboardShimmer()
          : controller.allVendorBooking.isEmpty
              ? Center(
                  child: Column(
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
                  ),
                )
              : ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return vendorBookingContainer(
                      context,
                      index,
                      controller.allVendorBooking[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return 15.0.kH;
                  },
                  itemCount: controller.allVendorBooking.length,
                ),
    );
  }

  Obx _pageWaiting(BuildContext context) {
    return Obx(
      () => controller.isLaoding.value
          ? dashboardShimmer()
          : controller.allVendorBooking.isEmpty
              ? Center(
                  child: Column(
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
                  ),
                )
              : ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return vendorBookingContainer(
                      context,
                      index,
                      controller.allVendorBooking[index],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return 15.0.kH;
                  },
                  itemCount: controller.allVendorBooking.length,
                ),
    );
  }

  Obx _pageDone(BuildContext context) {
    return Obx(() => controller.isLaoding.value
        ? dashboardShimmer()
        : controller.allVendorBooking.isEmpty
            ? Center(
                child: Column(
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
                ),
              )
            : ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return controller.todaycontainer.value
                      ? vendorBookingContainerToday(context, index,
                          controller.allVendorBooking[index], controller)
                      : vendorBookingContainer(
                          context,
                          index,
                          controller.allVendorBooking[index],
                        );
                },
                separatorBuilder: (context, index) {
                  return 15.0.kH;
                },
                itemCount: controller.allVendorBooking.length,
              ));
  }

  Stack _buildVendorHeader(BuildContext context) {
    return Stack(
      children: [
        vendorHeader(context, controller.waitingList.length),
        Align(
          alignment: Get.locale!.languageCode == "en"
              ? Alignment.topRight
              : Alignment.topLeft,
          child: SizedBox(
            width: context.screenWidth * .18,
            height: context.screenHeight * .06,
            child: Stack(
              children: [
                IconButton(
                    onPressed: () {
                      Get.to(() => const VendorWaitingList());
                    },
                    icon: SizedBox(
                        height: context.screenHeight * .4,
                        width: context.screenWidth * .09,
                        child: const RotatingImage(
                          image: 'assets/image/hourGlasses.png',
                        ))),
                Align(
                  alignment: Get.locale!.languageCode == "en"
                      ? Alignment.topLeft
                      : Alignment.topRight,
                  child: Container(
                    width: context.screenWidth * .045,
                    height: context.screenHeight * .03,
                    decoration: BoxDecoration(
                        color: AppTheme.lightAppColors.secondaryColor,
                        shape: BoxShape.circle),
                    child: Center(
                      child: Text(
                        controller.waitingList.length.toString(),
                        style: TextStyle(
                            color: AppTheme.lightAppColors.background,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Obx _pageTodya(BuildContext context) {
    return Obx(
      () => controller.isLaoding.value
          ? dashboardShimmer()
          : controller.todayVendorBooking.isEmpty
              ? Center(
                  child: Column(
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
                  ),
                )
              : Obx(() => controller.todayVendorBooking.isEmpty
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            VendorDashboardText.emptyText(
                                "Currently, there are no bookings available for you"
                                    .tr),
                          ],
                        )
                      ],
                    )
                  : ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return vendorBookingContainerToday(
                          context,
                          index,
                          controller.todayVendorBooking[index],
                          controller,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return 15.0.kH;
                      },
                      itemCount: controller.todayVendorBooking.length,
                    )),
    );
  }
}
