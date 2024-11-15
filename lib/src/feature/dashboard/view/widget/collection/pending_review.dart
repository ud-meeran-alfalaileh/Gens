import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/api/notification_controller.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/dashboard/view/widget/text/dashboard_text.dart';
import 'package:gens/src/feature/doctor_profile/controller/doctor_controller.dart';
import 'package:gens/src/feature/login/model/login_form_model.dart';
import 'package:gens/src/feature/login/view/widgte/collection/auth_form_widget.dart';
import 'package:gens/src/feature/profile/view/widget/collection/profile_collection.dart';
import 'package:get/get.dart';

Container reviewContainer(BuildContext context) {
  final doctorController = Get.put(DoctorController());
  return Container(
    width: context.screenWidth,
    height: context.screenHeight,
    color: AppTheme.lightAppColors.black.withOpacity(0.2),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
            child:
                doctorController.reviewPinding.first.reviewStatus == 'Pending'
                    ? pendingReviewContainer(context, doctorController)
                    : absentReviewContainer(context, doctorController)),
      ],
    ),
  );
}

Container pendingReviewContainer(
    BuildContext context, DoctorController doctorController) {
  final review = doctorController.reviewPinding.first;

  return Container(
    padding: const EdgeInsets.all(20),
    width: context.screenWidth * .84,
    decoration: BoxDecoration(
      color: AppTheme.lightAppColors.background,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Displaying the service name and details
        Get.locale!.languageCode == "en"
            ? DashboardText.reviewText(
                "Please rate your experience with '${review.serviceTitle}' by '${review.vendorName}' to help us improve",
              )
            : DashboardText.reviewText(
                "يرجى تقييم تجربتك مع '${review.serviceTitle}' بواسطة '${review.vendorName}' لمساعدتنا على التحسين",
              ),
        10.0.kH,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DashboardText.reviewSecText('On '.tr),
            DashboardText.reviewThText('${review.bookedDate} '),
          ],
        ),
        10.0.kH,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DashboardText.reviewSecText(' at '.tr),
            DashboardText.reviewThText(review.bookedTime)
          ],
        ),
        20.0.kH,

        Center(
          child: RatingBar.builder(
            initialRating: 5,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding:
                EdgeInsets.symmetric(horizontal: context.screenWidth * .002),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: AppTheme.lightAppColors.secondaryColor,
            ),
            onRatingUpdate: (rating) {
              doctorController.userRating.value = rating;
            },
          ),
        ),
        const SizedBox(height: 20),

        Row(
          children: [
            Text(
              "Write a review message:".tr,
              style: const TextStyle(fontFamily: "Inter", fontSize: 16),
            ),
          ],
        ),
        Stack(
          children: [
            AuthForm(
                maxLine: 2,
                formModel: FormModel(
                    controller: doctorController.messageController,
                    enableText: false,
                    hintText: "Enter you message here".tr,
                    invisible: false,
                    validator: null,
                    type: TextInputType.text,
                    inputFormat: [],
                    onTap: () {})),
            Obx(
              () => Align(
                  alignment: Get.locale!.languageCode == "en"
                      ? Alignment.topRight
                      : Alignment.topLeft,
                  child: doctorController.addingImage.value
                      ? Container(
                          width: 50,
                          height: 50,
                          padding: const EdgeInsets.all(28.0),
                          child: CircularProgressIndicator(
                            color: AppTheme.lightAppColors.primary,
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 9.0),
                          child: IconButton(
                              onPressed: () {
                                showPopupButtons(context, doctorController);
                              },
                              icon: Icon(
                                doctorController.serviceImage.value == ""
                                    ? Icons.attach_file_sharp
                                    : Icons.done,
                                color: doctorController.serviceImage.value == ""
                                    ? AppTheme.lightAppColors.primary
                                    : Colors.green,
                              )),
                        )),
            )
          ],
        ),
        15.0.kH,

        // Submit Button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: context.screenWidth * .25,
              child: AppButton(
                onTap: () {
                  doctorController.reviewPinding.clear();
                  doctorController.serviceImage.value = "";
                  doctorController.messageController.text = "";
                },
                title: 'later'.tr,
              ),
            ),
            SizedBox(
              width: context.screenWidth * .25,
              child: AppButton(
                onTap: () {
                  doctorController.postReview(
                      review.reviewId,
                      'Done',
                      NotificationModel(
                          title: "title",
                          message: "message",
                          imageURL: "imageURL",
                          externalIds: "externalIds"));
                },
                title: 'Submit'.tr,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

void showPopupButtons(BuildContext context, DoctorController controller) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: context.screenHeight * .18,
        width: context.screenWidth,
        decoration: BoxDecoration(
            color: AppTheme.lightAppColors.background,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(
          children: [
            SizedBox(
              height: context.screenHeight * .01,
            ),
            profileImageButton(context, () {
              controller.pickImages(context);
            }, "library".tr, Icons.image_outlined),
            const Divider(),
            10.0.kH,
            profileImageButton(context, () {
              controller.takeImages(context);
            }, "camera".tr, Icons.camera_alt_outlined),
            // profileImageButton(context, () {
            //   // controller.takeImages(token);
            // },
            // "Remove current picture", Icons.delete_outline_outlined),
          ],
        ),
      );
    },
  );
}

Container absentReviewContainer(
    BuildContext context, DoctorController doctorController) {
  final review = doctorController.reviewPinding.first;

  return Container(
    padding: const EdgeInsets.all(20),
    width: context.screenWidth * .8,
    decoration: BoxDecoration(
      color: AppTheme.lightAppColors.background,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.0.kH,
        Get.locale!.languageCode == 'en'
            ? DashboardText.reviewText(
                "Did you attend your appointment for '${doctorController.reviewPinding.first.serviceTitle}' by '${doctorController.reviewPinding.first.vendorName}'?",
              )
            : DashboardText.reviewText(
                "هل حضرت موعدك لـ '${doctorController.reviewPinding.first.serviceTitle}' بواسطة '${doctorController.reviewPinding.first.vendorName}'؟",
              ),
        10.0.kH,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DashboardText.reviewSecText('On '.tr),
            DashboardText.reviewThText('${review.bookedDate} '),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DashboardText.reviewSecText(' at '.tr),
            DashboardText.reviewThText(review.bookedTime)
          ],
        ),
        10.0.kH,

        // Submit Button
        doctorController.isAbsent.value
            ? const SizedBox.shrink()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: context.screenWidth * .32,
                    child: AppButton(
                      onTap: () {
                        // doctorController.isAbsent.value = true;
                        doctorController.postReview(
                            review.reviewId,
                            'Pending',
                            NotificationModel(
                                title: 'title',
                                message: 'message',
                                imageURL: 'imageURL',
                                externalIds: "externalIds"));
                      },
                      title: 'Yes'.tr,
                    ),
                  ),
                  SizedBox(
                    width: context.screenWidth * .32,
                    child: AppButton(
                      onTap: () {
                        doctorController.isAbsent.value = true;
                      },
                      title: 'No'.tr,
                    ),
                  ),
                ],
              ),

        !doctorController.isAbsent.value
            ? const SizedBox.shrink()
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "let us know the reason below".tr,
                    style: const TextStyle(fontSize: 14, fontFamily: "Inter"),
                  ),
                  Stack(
                    children: [
                      AuthForm(
                          maxLine: 3,
                          formModel: FormModel(
                              controller: doctorController.messageController,
                              enableText: false,
                              hintText: "Enter you message here".tr,
                              invisible: false,
                              validator: null,
                              type: TextInputType.text,
                              inputFormat: [],
                              onTap: () {})),
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
                            doctorController.postReview(
                                review.reviewId,
                                "Pending",
                                NotificationModel(
                                    title: "title",
                                    message: "message",
                                    imageURL: "imageURL",
                                    externalIds: "externalIds"));
                          },
                          title: 'Attended'.tr,
                        ),
                      ),
                      SizedBox(
                        width: context.screenWidth * .32,
                        child: AppButton(
                          onTap: () {
                            doctorController.postReview(
                                review.reviewId,
                                "No-show",
                                NotificationModel(
                                    title: "title",
                                    message: "message",
                                    imageURL: "imageURL",
                                    externalIds: ''));
                          },
                          title: 'Submit'.tr,
                        ),
                      ),
                    ],
                  ),
                ],
              )
      ],
    ),
  );
}
