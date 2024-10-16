import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/dashboard/view/widget/collection/dashboard_shimmer.dart';
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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Function to load data
  Future<void> _loadData() async {
    controller.getFormattedTodayDate();
    await controller.getVendorBoooking(context);
    // await vendorController.getVendorsById(); // Uncomment if needed
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() => Stack(
                    children: [
                      vendorHeader(context, controller.waitingList.length),
                      Align(
                        alignment: Get.locale!.languageCode == "en"
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        child: SizedBox(
                          width: context.screenWidth * .15,
                          height: context.screenHeight * .03,
                          child: Stack(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Get.to(() => const VendorWaitingList());
                                  },
                                  icon: Icon(
                                    Icons.calendar_month_outlined,
                                    size: 30,
                                    color: AppTheme.lightAppColors.primary,
                                  )),
                              Align(
                                alignment: Get.locale!.languageCode == "en"
                                    ? Alignment.topLeft
                                    : Alignment.topRight,
                                child: Container(
                                  width: context.screenWidth * .045,
                                  height: context.screenHeight * .03,
                                  decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle),
                                  child: Center(
                                    child: Text(
                                      controller.waitingList.length.toString(),
                                      style: TextStyle(
                                          color: AppTheme
                                              .lightAppColors.background,
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
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: vendorDashboardContainerRow(controller)),
              ),
              Obx(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          100.0.kH,
                                          Image.asset(
                                            'assets/image/empty-box.png',
                                            width: 200,
                                          ),
                                          10.0.kH,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              VendorDashboardText.emptyText(
                                                  "Currently, there are no bookings available for you"
                                                      .tr),
                                            ],
                                          )
                                        ],
                                      )
                                    : SizedBox(
                                        child: ListView.separated(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return controller
                                                      .todaycontainer.value
                                                  ? vendorBookingContainerToday(
                                                      context,
                                                      index,
                                                      controller
                                                              .filteredBooking[
                                                          index],
                                                    )
                                                  : vendorBookingContainer(
                                                      context,
                                                      index,
                                                      controller
                                                              .filteredBooking[
                                                          index],
                                                    );
                                            },
                                            separatorBuilder: (context, index) {
                                              return 15.0.kH;
                                            },
                                            itemCount: controller
                                                .filteredBooking.length),
                                      )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: VendorDashboardText.mainText(
                                            "Today Booking".tr),
                                      ),
                                      20.0.kH,
                                      controller.todayVendorBooking.isEmpty
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "assets/image/no.png",
                                                  width:
                                                      context.screenWidth * .2,
                                                  height:
                                                      context.screenHeight * .1,
                                                ),
                                                20.0.kW,
                                                ServicesText.secText(
                                                    "there is no booking for today"
                                                        .tr),
                                              ],
                                            )
                                          : SizedBox(
                                              child: ListView.separated(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return vendorBookingContainerToday(
                                                      context,
                                                      index,
                                                      controller
                                                              .todayVendorBooking[
                                                          index],
                                                    );
                                                  },
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return 15.0.kH;
                                                  },
                                                  itemCount: controller
                                                      .todayVendorBooking
                                                      .length),
                                            ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: VendorDashboardText.mainText(
                                            "Upcoming Booking".tr),
                                      ),
                                      20.0.kH,
                                      SizedBox(
                                        child: ListView.separated(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
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
                                            itemCount: controller
                                                .vendorBooking.length),
                                      ),
                                    ],
                                  ),
                          ),
              ),
              80.0.kH
            ],
          ),
        ),
      ),
    );
  }
}
