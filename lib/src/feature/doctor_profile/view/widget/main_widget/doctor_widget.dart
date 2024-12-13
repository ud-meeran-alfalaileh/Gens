import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
import 'package:gens/src/feature/fav_page/fav_controller.dart';
import 'package:get/get.dart';

class DoctorWidget extends StatefulWidget {
  const DoctorWidget({super.key, required this.model, required this.type});
  final String type;
  final int model;

  @override
  State<DoctorWidget> createState() => _DoctorWidgetState();
}

class _DoctorWidgetState extends State<DoctorWidget> {
  final controller = Get.put(DoctorController());
  final favController = Get.put(FavController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.isLoading.value = true;
      init();
    });

    super.initState();
  }

  Future<void> init() async {
    await controller.getVendorsById(widget.model);
    controller.srevice.value = 0;
    await controller.getVendorServices(widget.model);
  }

  @override
  void dispose() {
    controller.sreviceDescription.value = '';
    controller.srevice.value = 0;
    super.dispose();
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    if (widget.type == 'Fav') {
                                      favController.getFavDoctor();
                                    }
                                    Get.back();
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: AppTheme.lightAppColors.black
                                        .withOpacity(.8),
                                  )),
                              DoctorText.mainText("Details".tr),
                              Obx(
                                () => GestureDetector(
                                  onTap: () async {
                                    if (controller.isFavString.value ==
                                        'null') {
                                      controller.isFav.value = false;
                                      controller.isFavString.value = "fasle";
                                      controller.addFav(widget.model);
                                    } else {
                                      if (controller.favourite.value!.isFav ==
                                          false) {
                                        controller.isFav.value = true;
                                        controller.isFavString.value = "true";

                                        controller.putFav(
                                            widget.model,
                                            true,
                                            controller
                                                .favourite.value!.favoriteId);
                                      } else if (controller
                                              .favourite.value!.isFav ==
                                          true) {
                                        controller.isFav.value = false;
                                        controller.isFavString.value = "fasle";

                                        controller.putFav(
                                            widget.model,
                                            false,
                                            controller
                                                .favourite.value!.favoriteId);
                                      }
                                    }
                                  },
                                  child: Image.asset(
                                    controller.isFav.value == false
                                        ? "assets/image/heart.png"
                                        : "assets/image/lover.png",
                                    height: 20,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        vendorHeader(
                          context,
                        ),
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
                                      "patients".tr),
                                  doctorRowCircle(
                                      context,
                                      "assets/image/review.svg",
                                      storyShortenText(controller
                                          .doctor.value!.avgRating
                                          .toString()),
                                      "rating".tr),
                                  GestureDetector(
                                    onTap: () {
                                      _showReviewsBottomSheet(context);
                                    },
                                    child: doctorRowCircle(
                                        context,
                                        "assets/image/messages.svg",
                                        controller.doctor.value!.reviewCount
                                            .toString(),
                                        "Reviews".tr),
                                  ),
                                ],
                              ),
                              (context.screenHeight * .03).kH,
                              Row(
                                children: [
                                  DoctorText.mainText("About Me".tr),
                                  DoctorText.mainText(
                                      controller.doctor.value!.name),
                                ],
                              ),
                              (context.screenHeight * .01).kH,
                              Obx(
                                () => GestureDetector(
                                  onTap: () {
                                    controller.toggleExpanded();
                                  },
                                  child: Text.rich(TextSpan(
                                    text: controller.isExpanded.value ||
                                            controller.doctor.value!.description
                                                    .length <=
                                                maxLength
                                        ? controller.doctor.value!.description
                                        : controller.doctor.value!.description
                                            .substring(0, maxLength),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Inter',
                                      color:
                                          AppTheme.lightAppColors.subTextcolor,
                                    ),
                                    children: [
                                      controller.doctor.value!.description
                                                  .length ==
                                              90
                                          ? TextSpan(
                                              text: controller.isExpanded.value
                                                  ? " see less".tr
                                                  : " see more".tr,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: AppTheme
                                                    .lightAppColors.primary,
                                                fontFamily: 'Inter',
                                              ),
                                            )
                                          : const TextSpan(text: '')
                                    ],
                                  )),
                                ),
                              ),
                              (context.screenHeight * .03).kH,
                              DoctorText.mainText("Working Time".tr),
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
                              DoctorText.mainText("Services".tr),
                              (context.screenHeight * .01).kH,
                              controller.services.isEmpty
                                  ? Text(
                                      'There is no services for this vendor'.tr,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: 'Inter',
                                        color: AppTheme
                                            .lightAppColors.subTextcolor,
                                      ),
                                    )
                                  : _servicesList(context),
                              10.0.kH,
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  controller.srevice.value == 0
                                      ? const SizedBox.shrink()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Get.locale!.languageCode == "en"
                                                ? Text(
                                                    "Start from ${controller.servicePrice.value.toString()}JOD")
                                                : Text(
                                                    "ابدأ من ${controller.servicePrice.value.toString()} دينار"),
                                          ],
                                        ),
                                  Text(
                                    'Description'.tr,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Inter',
                                      color:
                                          AppTheme.lightAppColors.mainTextcolor,
                                    ),
                                  ),
                                  Text(
                                    controller.sreviceDescription.value,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Inter',
                                      color:
                                          AppTheme.lightAppColors.subTextcolor,
                                    ),
                                  ),
                                  10.0.kH,
                                  controller.sreviceAdvice.value == ''
                                      ? const SizedBox.shrink()
                                      : Text(
                                          'Advice'.tr,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontFamily: 'Inter',
                                            color: AppTheme
                                                .lightAppColors.mainTextcolor,
                                          ),
                                        ),
                                  Text(
                                    controller.sreviceAdvice.value,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Inter',
                                      color:
                                          AppTheme.lightAppColors.subTextcolor,
                                    ),
                                  ),
                                ],
                              ),
                              (context.screenHeight * .02).kH,
                              controller.doctor.value!.reviews.isEmpty
                                  ? const SizedBox.shrink()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        DoctorText.mainText("Reviews".tr),
                                        GestureDetector(
                                          onTap: () {
                                            _showReviewsBottomSheet(context);
                                          },
                                          child: Text(
                                            " see more".tr,
                                            style: TextStyle(
                                                color: AppTheme
                                                    .lightAppColors.primary),
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
                                        ? Get.snackbar("Error".tr,
                                            "Select Service before Continue".tr)
                                        : Get.to(() => BookingPage(
                                              vendorId: controller
                                                  .doctor.value!.vendorId,
                                              type: 'New',
                                              bookId: controller.srevice.value,
                                              vendorPhone: controller
                                                  .doctor.value!.phone,
                                              advice: controller
                                                  .sreviceAdvice.value,
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

  _servicesList(BuildContext context) {
    return SizedBox(
      width: context.screenWidth,
      child: AlignedGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              controller.srevice.value = controller.services[index].serviceId;
              controller.sreviceDescription.value =
                  controller.services[index].description;
              controller.sreviceAdvice.value =
                  controller.services[index].advise;
              controller.servicePrice.value = controller.services[index].price;
            },
            child: Obx(
              () => Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: AppTheme.lightAppColors.maincolor),
                      borderRadius: BorderRadius.circular(20),
                      color: controller.srevice.value ==
                              controller.services[index].serviceId
                          ? AppTheme.lightAppColors.maincolor
                          : AppTheme.lightAppColors.background),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      controller.services[index].imageUrl == ''
                          ? const SizedBox.shrink()
                          : Container(
                              width: context.screenWidth * .18,
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
                      5.0.kH,
                      SizedBox(
                          width: 80.0,
                          child: Text(
                            controller.services[index].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: "Inter",
                                color: AppTheme.lightAppColors.mainTextcolor),
                          )),
                    ],
                  ))),
            ),
          );
        },
        itemCount: controller.services.length,
        crossAxisCount: 3,
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
          controller.doctor.value!.reviews[index].imgUrl == ''
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
                              controller.doctor.value!.reviews[index].imgUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Image.network(
                    controller.doctor.value!.reviews[index].imgUrl,
                    height: 90,
                  ),
                )
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
                    style: TextStyle(
                        color: AppTheme.lightAppColors.black,
                        fontFamily: "Inter",
                        fontSize: 16),
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

  vendorHeader(
    BuildContext context,
  ) {
    return SizedBox(
      height: context.screenHeight * .35,
      child: Stack(
        children: [
          // Image slider
          controller.imagesUrl.isNotEmpty
              ? Container(
                  width: context.screenWidth,
                  height: context.screenHeight * .3,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(controller.imagesUrl[0]),
                    ),
                  ),
                )
              : const Center(child: Text("No images available")),

          Positioned(
              bottom: 0,
              left: 30,
              right: 30,
              child: doctorContainer(context, controller.doctor.value!)),
        ],
      ),
    );
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
