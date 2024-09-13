import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gens/src/config/sizes/short_text.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/core/utils/loading_page.dart';
import 'package:gens/src/feature/booking/view/page/booking_page.dart';
import 'package:gens/src/feature/doctor_profile/controller/doctor_controller.dart';
import 'package:gens/src/feature/doctor_profile/view/widget/collection/doctor_container.dart';
import 'package:gens/src/feature/doctor_profile/view/widget/text/doctor_text.dart';
import 'package:get/get.dart';

class DoctorWidget extends StatefulWidget {
  const DoctorWidget({super.key, required this.model});
  final int model;

  @override
  State<DoctorWidget> createState() => _DoctorWidgetState();
}

class _DoctorWidgetState extends State<DoctorWidget> {
  final controller = Get.put(DoctorController());

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    await controller.getVendorsById(widget.model);
    await controller.getVendorServices(widget.model);
  }

  @override
  Widget build(BuildContext context) {
    int maxLength = 90;

    return SafeArea(
      bottom: false,
      child: Obx(
        () => Stack(
          children: [
            controller.isLoadingVendor.value
                ? const SizedBox.shrink()
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Get.back();
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: AppTheme.lightAppColors.black
                                      .withOpacity(.8),
                                )),
                            const Spacer(),
                            DoctorText.mainText("Details"),
                            const Spacer(),
                            40.0.kW
                          ],
                        ),
                        (context.screenHeight * .02).kH,
                        doctorContainer(context, controller.doctor.value!),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              (context.screenHeight * .02).kH,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  doctorRowCircle(
                                      context,
                                      "assets/image/profile-2.svg",
                                      controller.doctor.value!.pastBookings
                                          .toString(),
                                      "patients"),
                                  doctorRowCircle(
                                      context,
                                      "assets/image/review.svg",
                                      storyShortenText(controller
                                          .doctor.value!.avgRating
                                          .toString()),
                                      "rating"),
                                  doctorRowCircle(
                                      context,
                                      "assets/image/messages.svg",
                                      controller.doctor.value!.reviewCount
                                          .toString(),
                                      "reviews"),
                                ],
                              ),
                              (context.screenHeight * .03).kH,
                              DoctorText.mainText("About Me"),
                              (context.screenHeight * .01).kH,
                              Obx(
                                () => GestureDetector(
                                  onTap: () {
                                    controller.toggleExpanded();
                                  },
                                  child: Text.rich(
                                    TextSpan(
                                      text: controller.isExpanded.value ||
                                              controller.doctor.value!
                                                      .description.length <=
                                                  maxLength
                                          ? controller.doctor.value!.description
                                          : controller.doctor.value!.description
                                              .substring(0, maxLength),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Inter',
                                        color: AppTheme
                                            .lightAppColors.subTextcolor,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: controller.isExpanded.value
                                              ? " see less".tr
                                              : " see more".tr,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                AppTheme.lightAppColors.primary,
                                            fontFamily: 'Inter',
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              (context.screenHeight * .03).kH,
                              DoctorText.mainText("Working Time"),
                              (context.screenHeight * .01).kH,
                              controller.doctor.value!.workingTime != ""
                                  ? Column(
                                      children: [
                                        Text(
                                          controller.doctor.value!.workingTime,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Inter',
                                            color: AppTheme
                                                .lightAppColors.subTextcolor,
                                          ),
                                        ),
                                        (context.screenHeight * .03).kH,
                                      ],
                                    )
                                  : const SizedBox.shrink(),
                              DoctorText.mainText("Services"),
                              (context.screenHeight * .01).kH,
                              controller.services.isEmpty
                                  ? const Text(
                                      "there is no services for this vendor")
                                  : _servicesList(context),
                              10.0.kH,
                              Center(
                                  child: Text(
                                controller.sreviceDescription.value,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'Inter',
                                  color: AppTheme.lightAppColors.subTextcolor,
                                ),
                              )),
                              // (context.screenHeight * .05).kH,
                              controller.doctor.value!.reviews.isEmpty
                                  ? const SizedBox.shrink()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        DoctorText.mainText("Reviews"),
                                        GestureDetector(
                                          onTap: () {
                                            _showReviewsBottomSheet(
                                                context); // Show bottom sheet on tap
                                          },
                                          child: const Text(
                                            "See all",
                                            style: TextStyle(
                                                color: Colors
                                                    .blue), // Make it look clickable
                                          ),
                                        )
                                      ],
                                    ),
                              (context.screenHeight * .01).kH,
                              controller.doctor.value!.reviews.isEmpty
                                  ? const SizedBox.shrink()
                                  : SizedBox(
                                      child: ListView.separated(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return _builderReviewContainer(
                                                index);
                                          },
                                          separatorBuilder: (context, index) {
                                            return Divider(
                                              color: AppTheme
                                                  .lightAppColors.primary
                                                  .withOpacity(0.3),
                                              height: 3,
                                            );
                                          },
                                          itemCount: 1),
                                    ),
                              AppButton(
                                  onTap: () {
                                    controller.srevice.value == 0
                                        ? Get.snackbar("Error",
                                            "Select Service befor Continue")
                                        : Get.to(() => BookingPage(
                                              vendorId: controller
                                                  .doctor.value!.vendorId,
                                            ));
                                  },
                                  title: "Book Appointment".tr)
                            ],
                          ),
                        ),
                        40.0.kH
                      ],
                    ),
                  ),
            controller.isLoadingVendor.value
                ? loadingPage(context)
                : const SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  SizedBox _servicesList(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * .1,
      width: context.screenWidth,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                controller.srevice.value = controller.services[index].serviceId;
                controller.sreviceDescription.value =
                    controller.services[index].description;
              },
              child: Obx(
                () => Container(
                    width: context.screenWidth * .4,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: AppTheme.lightAppColors.maincolor),
                        borderRadius: BorderRadius.circular(20),
                        color: controller.srevice.value ==
                                controller.services[index].serviceId
                            ? AppTheme.lightAppColors.maincolor
                            : AppTheme.lightAppColors.background),
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        10.0.kW,
                        controller.services[index].imageUrl == ''
                            ? const SizedBox.shrink()
                            : Container(
                                width: context.screenWidth * .12,
                                height: context.screenHeight * .08,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        controller.services[index].imageUrl,
                                      ),
                                      fit: BoxFit.cover,
                                    )),
                              ),
                        10.0.kW,
                        SizedBox(
                            width: 80.0,
                            child: Text(controller.services[index].title)),
                      ],
                    ))),
              ),
            );
          },
          separatorBuilder: (context, index) {
            return 10.0.kW;
          },
          itemCount: controller.services.length),
    );
  }

  _builderReviewContainer(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.lightAppColors.maincolor,
                backgroundImage:
                    controller.doctor.value!.reviews[index].userImage == "" ||
                            controller.doctor.value!.reviews[index].userImage ==
                                'string'
                        ? const AssetImage(
                            "assets/image/profileIcon.png",
                          )
                        : NetworkImage(
                            controller.doctor.value!.reviews[index].userImage),
                radius: 30,
              ),
              10.0.kW,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DoctorText.secText(
                      controller.doctor.value!.reviews[index].userFirstName),
                  5.0.kH,
                  Row(
                    children: [
                      DoctorText.thirdText(controller
                          .doctor.value!.reviews[index].rating
                          .toString()),
                      7.0.kW,
                      Row(
                        children: _buildStars(controller
                            .doctor.value!.reviews[index].rating
                            .toDouble()),
                      ),
                      5.0.kW, // Adding some space between stars and number
                    ],
                  ),
                ],
              ),
            ],
          ),
          10.0.kH,
          DoctorText.reviewDesText(
              controller.doctor.value!.reviews[index].description),
        ],
      ),
    );
  }

  List<Widget> _buildStars(double rating) {
    int fullStars = rating.floor(); // Full stars (rounded down)
    bool hasHalfStar =
        rating - fullStars >= 0.5; // Check if half star is needed
    List<Widget> stars = [];

    // Add full stars
    for (int i = 0; i < fullStars; i++) {
      stars.add(const Icon(Icons.star, color: Colors.amber, size: 16));
    }

    // Add half star if applicable
    if (hasHalfStar) {
      stars.add(const Icon(Icons.star_half, color: Colors.amber, size: 16));
    }

    // Add empty stars to complete 5 stars display
    for (int i = fullStars + (hasHalfStar ? 1 : 0); i < 5; i++) {
      stars.add(const Icon(Icons.star_border, color: Colors.amber, size: 16));
    }

    return stars;
  }

  Column doctorRowCircle(BuildContext context, image, number, title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          width: 65,
          height: 60,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: AppTheme.lightAppColors.maincolor),
          child: SvgPicture.asset(image),
        ),
        (context.screenHeight * .01).kH,
        DoctorText.secText("$number"),
        DoctorText.thirdText(title),
      ],
    );
  }

  void _showReviewsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppTheme.lightAppColors.background,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7, // Height of the sheet (70% of screen height)
          minChildSize: 0.4, // Minimum height when dragged down
          maxChildSize: 1.0, // Maximum height when dragged up
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    "All Reviews",
                    // style: Theme.of(context).textTheme.headline6,
                  ),
                  10.0.kH,
                  Expanded(
                    child: ListView.separated(
                      controller:
                          scrollController, // Ensure the list scrolls inside the bottom sheet
                      itemBuilder: (context, index) {
                        return _builderReviewContainer(
                            index); // Reuse the existing review builder
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          color:
                              AppTheme.lightAppColors.primary.withOpacity(0.3),
                          height: 3,
                        );
                      },
                      itemCount: controller
                          .doctor.value!.reviews.length, // Display all reviews
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
