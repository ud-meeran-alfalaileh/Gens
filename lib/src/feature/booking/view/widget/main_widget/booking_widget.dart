import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/booking/controller/booking_controller.dart';
import 'package:gens/src/feature/booking/view/widget/collection/booking_containers.dart';
import 'package:gens/src/feature/booking/view/widget/collection/booking_success.dart';
import 'package:gens/src/feature/doctor_profile/view/widget/text/doctor_text.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class BookingWidget extends StatelessWidget {
  const BookingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BookingController());
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
                DoctorText.mainText("Booking Appointment"),
                const Spacer(),
                (30.0).kW,
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 10, bottom: 30),
            child: SizedBox(
              height: context.screenHeight,
              child: Column(
                children: [
                  Row(
                    children: [
                      DoctorText.mainText("Select Date"),
                    ],
                  ),
                  (context.screenHeight * .02).kH,
                  Obx(
                    () => calendarContainer(controller),
                  ),
                  (context.screenHeight * .03).kH,
                  Row(
                    children: [
                      DoctorText.mainText("Select Hour"),
                    ],
                  ),
                  (context.screenHeight * .01).kH,
                  hourContainer(context, controller),
                  (context.screenHeight * .02).kH,
                  AppButton(
                      onTap: () {
                        if (controller.selectedDay.value == null) {
                          showTopSnackBar(
                            Overlay.of(context),
                            CustomSnackBar.error(
                              message: 'Please Select a Day'.tr,
                            ),
                          );
                        } else if (controller.hourSelected.value == "") {
                          showTopSnackBar(
                            Overlay.of(context),
                            CustomSnackBar.error(
                              message: 'Please Select a Hour'.tr,
                            ),
                          );
                        } else {
                          print(DateFormat.yMMMMd()
                              .format(controller.focusedDay.value));
                          print(controller.hourSelected.value);
                          successBookingDialog(context, controller);
                        }
                      },
                      title: "Book Appointment".tr)
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
