import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/loading_page.dart';
import 'package:gens/src/feature/history/model/history_model.dart';
import 'package:gens/src/feature/vendor_dashboard/controller/vendor_dashboard_controoler.dart';
import 'package:gens/src/feature/vendor_dashboard/view/widget/text/vendor_dashboard_text.dart';
import 'package:gens/src/feature/vendor_services/view/widget/text/services_text.dart';
import 'package:get/get.dart';

class VendorDashboardWidget extends StatefulWidget {
  const VendorDashboardWidget({super.key});

  @override
  State<VendorDashboardWidget> createState() => _VendorDashboardWidgetState();
}

class _VendorDashboardWidgetState extends State<VendorDashboardWidget> {
  final controller = Get.put(VendorDashboardController());
  @override
  void initState() {
    // controller.getFormattedTodayDate();
    // controller.getVendorBoooking(context);
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
                  Obx(
                    () => controller.vendorBooking.isEmpty
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
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                                          width: context.screenWidth * .2,
                                          height: context.screenHeight * .1,
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
                                          itemBuilder: (context, index) {
                                            return vendorBookingContainer(
                                                context,
                                                index,
                                                controller
                                                    .todayVendorBooking[index],
                                                "today");
                                          },
                                          separatorBuilder: (context, index) {
                                            return 15.0.kH;
                                          },
                                          itemCount: controller
                                              .todayVendorBooking.length),
                                    ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
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
                                          "allDay");
                                    },
                                    separatorBuilder: (context, index) {
                                      return 15.0.kH;
                                    },
                                    itemCount: controller.vendorBooking.length),
                              ),
                              60.0.kH,
                            ],
                          ),
                  )
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

  vendorBookingContainer(
      BuildContext context, index, VendorBooking model, listType) {
    RxBool statusUpadating = false.obs;

    return Obx(
      () => Container(
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
                  backgroundImage: NetworkImage(model.userImage),
                ),
                10.0.kW,
                VendorDashboardText.secText(model.userName),
                const Spacer(),
                IconButton(
                    onPressed: () {
                      controller.makePhoneCall(model.userPhoneNumber);
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
                          model, statusUpadating, context, "Upcoming", "allDay")
                      : model.status == "Upcoming"
                          ? listType == "today"
                              ? statusWidget(model, statusUpadating, context,
                                  "Done", "today")
                              : const SizedBox.shrink()
                          : statusWidget(model, statusUpadating, context,
                              "Finished", "allDay")
            ])
          ],
        ),
      ),
    );
  }

  GestureDetector statusWidget(VendorBooking model, RxBool statusUpadating,
      BuildContext context, status, listType) {
    return GestureDetector(
      onTap: () {
        status == "Finished"
            ? null
            : controller.updateBookingStatus(
                '$status', model.id, model, statusUpadating);
        // model.status = "Upcoming";
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: context.screenHeight * .04,
        decoration: BoxDecoration(
            color: model.status == "Done"
                ? Colors.green
                : model.status == "Upcoming"
                    ? listType == "today"
                        ? AppTheme.lightAppColors.primary
                        : AppTheme.lightAppColors.bordercolor
                    : AppTheme.lightAppColors.primary,
            borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Text(
            // model.status == "Pending"
            //     ? "Accept"
            //     : model.status == "Upcoming"
            //         ? "Done"
            //         :
            model.status,
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
