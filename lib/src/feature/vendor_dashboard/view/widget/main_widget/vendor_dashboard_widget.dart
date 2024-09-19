import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/core/utils/loading_page.dart';
import 'package:gens/src/feature/vendor_dashboard/controller/vendor_dashboard_controoler.dart';
import 'package:gens/src/feature/vendor_dashboard/view/widget/collection/bednor_dashboard_collection.dart';
import 'package:gens/src/feature/vendor_dashboard/view/widget/text/vendor_dashboard_text.dart';
import 'package:gens/src/feature/vendor_profile/controller/vendor_profile_controller.dart';
import 'package:gens/src/feature/vendor_services/view/widget/text/services_text.dart';
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
    controller.getFormattedTodayDate();
    controller.getVendorBoooking(context);
    // vendorController.getVendorsById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Obx(
          () => Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  vendorHeader(context),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Center(child: vendorDashboardContainerRow(controller)),
                  ),
                  Obx(
                    () => controller.allVendorBooking.isEmpty
                        ? Column(
                            children: [
                              100.0.kH,
                              Image.asset(
                                'assets/image/empty-box.png',
                                width: 200,
                              ),
                              10.0.kH,
                              VendorDashboardText.emptyText(
                                  "Currently, there are no bookings available for you"),
                            ],
                          )
                        :
                        /////Filteredlist
                        Obx(
                            () => controller.isFilterd.value
                                ? controller.filteredBooking.isEmpty
                                    ? Column(
                                        children: [
                                          100.0.kH,
                                          Image.asset(
                                            'assets/image/empty-box.png',
                                            width: 200,
                                          ),
                                          10.0.kH,
                                          VendorDashboardText.emptyText(
                                              "Currently, there are no bookings available for you"),
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
                                            "Today Booking"),
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
                                                    "there is no booking for today"),
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
                                            "Upcoming Booking"),
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
              controller.isLaoding.value
                  ? loadingPage(context)
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
