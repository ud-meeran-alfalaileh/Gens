import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/dashboard/controller/dashboard_controller.dart';
import 'package:gens/src/feature/dashboard/view/widget/collection/dashboard_doctor_container.dart';
import 'package:gens/src/feature/dashboard/view/widget/collection/dashboard_row.dart';
import 'package:gens/src/feature/dashboard/view/widget/text/dashboard_text.dart';
import 'package:gens/src/feature/doctor_profile/controller/doctor_controller.dart';
import 'package:gens/src/feature/history/view/widget/collection/search_form.dart';
import 'package:gens/src/feature/login/model/login_form_model.dart';
import 'package:gens/src/feature/login/view/widgte/collection/auth_form_widget.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class DashboradWidget extends StatefulWidget {
  const DashboradWidget({super.key});

  @override
  State<DashboradWidget> createState() => _DashboradWidgetState();
}

class _DashboradWidgetState extends State<DashboradWidget> {
  final controller = Get.put(DashboardController());
  final doctorController = Get.put(DoctorController());
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Stack(
        children: [
          SizedBox(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  scrolledUnderElevation: 0,
                  pinned: false,
                  backgroundColor: Colors.transparent,
                  expandedHeight: context.screenHeight * .1,
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 25),
                    child: Row(
                      children: [
                        Builder(
                          builder: (context) => GestureDetector(
                              onTap: () => Scaffold.of(context).openDrawer(),
                              child: const Icon(
                                Icons.menu,
                                size: 30,
                              )),
                        ),
                        const Spacer(),
                        Image.asset(
                          "assets/image/Logo2 2.png",
                          height: context.screenHeight * .032,
                        ),
                        const Spacer(),
                        16.0.kW,
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: SearchForm(
                          search: SearchFormEntitiy(
                            hintText: "searchDoctor".tr,
                            type: TextInputType.name,
                            ontap: () {},
                            enableText: false,
                            onChange: (value) {
                              controller.searchValue.value =
                                  controller.searchController.text;
                              doctorController.searchDoctors(controller
                                  .searchValue.value); // Call the search method
                            },
                            searchController: controller.searchController,
                          ),
                        ),
                      ),
                      Obx(
                        () => controller.searchValue.value == ""
                            ? Column(
                                children: [
                                  (context.screenHeight * .02).kH,
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: Get.locale?.languageCode == "en"
                                            ? 20
                                            : 0,
                                        right: Get.locale?.languageCode == "en"
                                            ? 0
                                            : 20),
                                    child: dashboardContainerRow(controller),
                                  ),
                                  (context.screenHeight * .01).kH,
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10),
                                    child: Row(
                                      children: [
                                        DashboardText.thirdText(doctorController
                                            .filteredDoctors.length
                                            .toString()),
                                        DashboardText.secText(" founds".tr),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    child: doctorController.doctors.isEmpty
                                        ? Shimmer.fromColors(
                                            baseColor: Colors.grey[300]!,
                                            highlightColor: Colors.grey[100]!,
                                            child: ListView.separated(
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              padding: const EdgeInsets.only(
                                                  top: 10,
                                                  left: 20,
                                                  right: 20,
                                                  bottom: 90),
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  height: 150,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20)),
                                                  margin: const EdgeInsets.only(
                                                      bottom: 10),
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) {
                                                return 20.0.kH;
                                              },
                                              itemCount:
                                                  6, // Show 6 shimmer placeholders
                                            ),
                                          )
                                        : ListView.separated(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            padding: const EdgeInsets.only(
                                                top: 10,
                                                left: 20,
                                                right: 20,
                                                bottom: 90),
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return doctorDashboardContainer(
                                                  context,
                                                  doctorController
                                                      .filteredDoctors[index],
                                                  doctorController);
                                            },
                                            separatorBuilder: (context, index) {
                                              return 20.0.kH;
                                            },
                                            itemCount: doctorController
                                                .filteredDoctors.length,
                                          ),
                                  )
                                ],
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: ListView.separated(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    padding: const EdgeInsets.only(
                                        top: 10,
                                        left: 20,
                                        right: 20,
                                        bottom: 90),
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return doctorDashboardContainer(
                                          context,
                                          controller
                                                  .searchController.text.isEmpty
                                              ? doctorController
                                                  .filteredDoctors[index]
                                              : doctorController
                                                  .filteredDoctors[index],
                                          doctorController);
                                    },
                                    separatorBuilder: (context, iindex) {
                                      return 20.0.kH;
                                    },
                                    itemCount: doctorController
                                        .filteredDoctors.length)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          doctorController.reviewPinding.isEmpty
              ? const SizedBox.shrink()
              : reviewContainer(context)
        ],
      ),
    );
  }

  Container reviewContainer(BuildContext context) {
    return Container(
      width: context.screenWidth,
      height: context.screenHeight,
      color: AppTheme.lightAppColors.black.withOpacity(0.2),
      child: Center(
          child: Container(
        padding: const EdgeInsets.all(20),
        width: context.screenWidth * .8,
        height: context.screenHeight * .5,
        decoration: BoxDecoration(
          color: AppTheme.lightAppColors.background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying the review status
            // Text(
            //   doctorController.reviewPinding.first.reviewStatus,
            //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            // ),
            10.0.kH,

            // Displaying the service name and details
            DashboardText.reviewText(
              "Please rate your experience with '${doctorController.reviewPinding.first.serviceTitle}' by '${doctorController.reviewPinding.first.vendorName}' to help us improve.",
            ),
            10.0.kH,
            Row(
              children: [
                DashboardText.reviewSecText('On '),
                DashboardText.reviewThText(
                    '${doctorController.reviewPinding.first.bookedDate} '),
                DashboardText.reviewSecText(' at '),
                DashboardText.reviewThText(
                    doctorController.reviewPinding.first.bookedTime)
              ],
            ),
            10.0.kH,

            Center(
              child: RatingBar.builder(
                initialRating: 1,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  doctorController.userRating.value = rating;
                },
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              "Write a review message:",
              style: TextStyle(fontSize: 16),
            ),
            Stack(
              children: [
                AuthForm(
                    maxLine: 3,
                    formModel: FormModel(
                        controller: doctorController.messageController,
                        enableText: false,
                        hintText: "Enter you message here",
                        invisible: false,
                        validator: null,
                        type: TextInputType.text,
                        inputFormat: [],
                        onTap: () {})),
                Obx(
                  () => Align(
                      alignment: Alignment.topRight,
                      child: doctorController.addingImage.value
                          ? Container(
                              width: 50,
                              height: 50,
                              padding: const EdgeInsets.all(18.0),
                              child: CircularProgressIndicator(
                                color: AppTheme.lightAppColors.primary,
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                doctorController.pickImages(context);
                              },
                              icon: Icon(
                                doctorController.serviceImage.value == ""
                                    ? Icons.attach_file_sharp
                                    : Icons.done,
                                color: doctorController.serviceImage.value == ""
                                    ? AppTheme.lightAppColors.primary
                                    : Colors.green,
                              ))),
                )
              ],
            ),
            20.0.kH,

            // Submit Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: context.screenWidth * .32,
                  child: AppButton(
                    onTap: () {
                      if (doctorController.messageController.text.isEmpty ||
                          doctorController.serviceImage.value == '') {
                        null;
                      } else {
                        doctorController.postReview(
                            doctorController.reviewPinding.first.reviewId);
                      }
                    },
                    title: 'Submit',
                  ),
                ),
                SizedBox(
                  width: context.screenWidth * .32,
                  child: AppButton(
                    onTap: () {
                      doctorController.reviewPinding.clear();
                      doctorController.serviceImage.value = "";
                      doctorController.messageController.text = "";
                    },
                    title: 'Submit later',
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
