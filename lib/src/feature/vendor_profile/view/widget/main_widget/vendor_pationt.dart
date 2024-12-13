import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gens/src/config/sizes/short_text.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/doctor_profile/view/widget/text/doctor_text.dart';
import 'package:gens/src/feature/profile/view/widget/text/profile_text.dart';
import 'package:gens/src/feature/vendor_profile/controller/vendor_profile_controller.dart';
import 'package:gens/src/feature/vendor_profile/view/widget/collection/all_patient_widget.dart';
import 'package:get/get.dart';

class VendorPationt extends StatefulWidget {
  const VendorPationt({super.key});

  @override
  State<VendorPationt> createState() => _VendorPationtState();
}

class _VendorPationtState extends State<VendorPationt> {
  final controller = Get.put(VendorProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => const AllPatientWidget(),
                        transition: Transition.downToUp);
                  },
                  child: doctorRowCircle(
                      context,
                      "assets/image/profile-2.svg",
                      controller.vendor.value.pastBookings.toString(),
                      "patients".tr),
                ),
                doctorRowCircle(
                    context,
                    "assets/image/review.svg",
                    storyShortenText(
                        controller.vendor.value.avgRating.toString()),
                    "rating".tr),
                doctorRowCircle(context, "assets/image/messages.svg",
                    controller.vendor.value.reviewCount.toString(), "reviews"),
              ],
            ),
            30.0.kH,
            Row(
              children: [
                ProfileText.mainText("Reviews".tr),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    _showReviewsBottomSheet(context);
                  },
                  child: ProfileText.secText(" see more".tr),
                )
              ],
            ),
            10.0.kH,
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return _builderReviewContainer(
                    index); // Reuse the existing review builder
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: AppTheme.lightAppColors.primary.withOpacity(0.3),
                  height: 3,
                );
              },
              itemCount: controller.vendor.value.reviews.length > 4
                  ? 4
                  : controller
                      .vendor.value.reviews.length, // Display all reviews
            ),
          ],
        ),
      ),
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
                    controller.vendor.value.reviews[index].userImage == "" ||
                            controller.vendor.value.reviews[index].userImage ==
                                'string'
                        ? const AssetImage(
                            "assets/image/profileIcon.png",
                          )
                        : NetworkImage(
                            controller.vendor.value.reviews[index].userImage),
                radius: 30,
              ),
              10.0.kW,
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DoctorText.secText(
                      controller.vendor.value.reviews[index].userFirstName),
                  DoctorText.secText(
                      controller.vendor.value.reviews[index].userFirstName),
                  5.0.kH,
                  Row(
                    children: [
                      DoctorText.thirdText(controller
                          .vendor.value.reviews[index].rating
                          .toString()),
                      7.0.kW,
                      Row(
                        children: _buildStars(controller
                            .vendor.value.reviews[index].rating
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
              controller.vendor.value.reviews[index].description),
          controller.vendor.value.reviews[index].imgUrl == ''
              ? const SizedBox.shrink()
              : GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              controller.vendor.value.reviews[index].imgUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Image.network(
                    controller.vendor.value.reviews[index].imgUrl,
                    height: 90,
                  ),
                )
        ],
      ),
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
                  Text(
                    "All Reviews".tr,
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
                          .vendor.value.reviews.length, // Display all reviews
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

  List<Widget> _buildStars(double rating) {
    int fullStars = rating.floor(); // Full stars (rounded down)
    bool hasHalfStar =
        rating - fullStars >= 0.5; // Check if half star is needed
    List<Widget> stars = [];

    // Add full stars
    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star,
          color: AppTheme.lightAppColors.secondaryColor, size: 16));
    }

    // Add half star if applicable
    if (hasHalfStar) {
      stars.add(Icon(Icons.star_half,
          color: AppTheme.lightAppColors.secondaryColor, size: 16));
    }

    // Add empty stars to complete 5 stars display
    for (int i = fullStars + (hasHalfStar ? 1 : 0); i < 5; i++) {
      stars.add(Icon(Icons.star_border,
          color: AppTheme.lightAppColors.secondaryColor, size: 16));
    }

    return stars;
  }
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
