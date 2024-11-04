import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/booking/controller/booking_controller.dart';
import 'package:gens/src/feature/booking/view/widget/collection/booking_containers.dart';
import 'package:gens/src/feature/doctor_profile/controller/doctor_controller.dart';
import 'package:gens/src/feature/doctor_profile/view/widget/text/doctor_text.dart';
import 'package:gens/src/feature/vendor_services/view/widget/text/services_text.dart';
import 'package:gens/src/feature/waiting_list/view/page/waiting_list_page.dart';
import 'package:get/get.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class BookingWidget extends StatelessWidget {
  const BookingWidget(
      {super.key,
      required this.vendorId,
      required this.type,
      required this.vendorPhone,
      required this.bookId});
  final int? bookId;
  final String type;
  final int vendorId;
  final String vendorPhone;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookingController());
    final doctorController = Get.put(DoctorController());
    return SafeArea(
      bottom: false,
      child: CustomScrollView(slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          scrolledUnderElevation: 0,
          pinned: false,
          backgroundColor: Colors.transparent,
          expandedHeight: context.screenHeight * .1,
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
            child: Row(
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
                DoctorText.mainText("Booking Appointment".tr),
                const Spacer(),
                (30.0).kW,
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Obx(
            () => controller.isBooking.value
                ? Container(
                    width: context.screenWidth,
                    height: context.screenHeight,
                    color: AppTheme.lightAppColors.black.withOpacity(0.1),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.lightAppColors.primary,
                      ),
                    ),
                  )
                : Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 10, bottom: 30),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            DoctorText.mainText("Select Date".tr),
                          ],
                        ),
                        (context.screenHeight * .02).kH,
                        Obx(
                          () => calendarContainer(controller, vendorId),
                        ),
                        (context.screenHeight * .03).kH,
                        Row(
                          children: [
                            DoctorText.mainText("Select Hour".tr),
                          ],
                        ),
                        (context.screenHeight * .01).kH,
                        Obx(
                          () => controller.isLoading.value
                              ? CircularProgressIndicator(
                                  color: AppTheme.lightAppColors.primary,
                                )
                              : controller.workingHors.isEmpty
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          "assets/image/no.png",
                                          width: context.screenWidth * .2,
                                        ),
                                        20.0.kW,
                                        ServicesText.secText('noTime'.tr),
                                      ],
                                    )
                                  : hourContainer(context, controller),
                        ),
                        (context.screenHeight * .02).kH,
                        SizedBox(
                          width: context.screenWidth * .6,
                          child: AppButton(
                              onTap: () {
                                if (controller.selectedDay.value == null) {
                                  showTopSnackBar(
                                    Overlay.of(context),
                                    CustomSnackBar.error(
                                      message: 'Please Select a Day'.tr,
                                    ),
                                  );
                                } else if (controller.hourSelected.value ==
                                    "") {
                                  showTopSnackBar(
                                    Overlay.of(context),
                                    CustomSnackBar.error(
                                      message: 'Please Select a Hour'.tr,
                                    ),
                                  );
                                } else {
                                  // controller.isBooking.value = true;
                                  controller.postBooking(
                                      doctorController.srevice.value,
                                      vendorId,
                                      context,
                                      type,
                                      bookId,
                                      vendorPhone);
                                }
                              },
                              title: "Book Appointment".tr),
                        ),
                        10.0.kH,
                        Text(
                          "Don't see you Preference".tr,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: AppTheme.lightAppColors.black,
                            fontWeight: FontWeight
                                .w500, // Use FontWeight.bold for the bold variant
                          ),
                        ),
                        10.0.kH,
                        GestureDetector(
                            onTap: () {
                              Get.to(() => WaitingListPage(
                                    
                                    vendorId: vendorId,
                                    serviceId: doctorController.srevice.value,
                                    vendorPhone: vendorPhone.toString(),
                                  ));
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: context.screenWidth * .6,
                              decoration: BoxDecoration(
                                  color: AppTheme.lightAppColors.bordercolor,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Join the Wishing List".tr,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 15,
                                      color: AppTheme.lightAppColors.background,
                                      fontWeight: FontWeight
                                          .w500, // Use FontWeight.bold for the bold variant
                                    ),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    ),
                  ),
          ),
        ),
      ]),
    );
  }
}
