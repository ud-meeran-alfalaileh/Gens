import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/dashboard/view/widget/collection/dashboard_shimmer.dart';
import 'package:gens/src/feature/test.dart';
import 'package:gens/src/feature/vendor_dashboard/controller/vendor_dashboard_controoler.dart';
import 'package:gens/src/feature/vendor_dashboard/view/widget/collection/bednor_dashboard_collection.dart';
import 'package:gens/src/feature/vendor_dashboard/view/widget/main_widget/vendor_Done_widget.dart';
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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Function to load data
  Future<void> _loadData() async {
    Future.delayed(const Duration(milliseconds: 500)).whenComplete(() {
      controller.getFormattedTodayDate();
      controller.getVendorBoooking(context);
    });

    // await vendorController.getVendorsById(); // Uncomment if needed
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
              Container(
                constraints:
                    BoxConstraints(minHeight: context.screenHeight * 0.65),
                height: context.screenHeight * .7,
                child: PageView(
                  controller: controller.pageController,
                  onPageChanged: (index) {
                    controller.currentPageIndex.value = index;
                  },
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          _pageOne(context),
                        ],
                      ),
                    ),
                    const VendorDoneWidget(),
                  ],
                ),
              ),
              // 80.0.kH
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
              : Obx(
                  () => controller.isFilterd.value
                      ? controller.filteredBooking.isEmpty
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
                                return controller.todaycontainer.value
                                    ? vendorBookingContainerToday(
                                        context,
                                        index,
                                        controller.filteredBooking[index],
                                        controller)
                                    : vendorBookingContainer(
                                        context,
                                        index,
                                        controller.filteredBooking[index],
                                      );
                              },
                              separatorBuilder: (context, index) {
                                return 15.0.kH;
                              },
                              itemCount: controller.filteredBooking.length,
                            )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: VendorDashboardText.mainText(
                                  "Today Booking".tr),
                            ),
                            20.0.kH,
                            controller.todayVendorBooking.isEmpty
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        "assets/image/no.png",
                                        width: context.screenWidth * .2,
                                        height: context.screenHeight * .1,
                                      ),
                                      20.0.kW,
                                      ServicesText.secText(
                                          "there is no booking for today".tr),
                                    ],
                                  )
                                : ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
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
                                    itemCount:
                                        controller.todayVendorBooking.length,
                                  ),
                            controller.vendorBooking.isEmpty
                                ? SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: VendorDashboardText.mainText(
                                        "Upcoming Booking".tr),
                                  ),
                            20.0.kH,
                            ListView.separated(
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
                            ),
                          ],
                        ),
                ),
    );
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
                        child: RotatingImage())),
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
}
