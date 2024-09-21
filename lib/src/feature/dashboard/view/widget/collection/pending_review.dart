import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/app_button.dart';
import 'package:gens/src/feature/dashboard/view/widget/text/dashboard_text.dart';
import 'package:gens/src/feature/doctor_profile/controller/doctor_controller.dart';
import 'package:gens/src/feature/login/model/login_form_model.dart';
import 'package:gens/src/feature/login/view/widgte/collection/auth_form_widget.dart';
import 'package:get/get.dart';

Container reviewContainer(BuildContext context) {
  final doctorController = Get.put(DoctorController());
  return Container(
    width: context.screenWidth,
    height: context.screenHeight,
    color: AppTheme.lightAppColors.black.withOpacity(0.2),
    child: Center(
        child: doctorController.reviewPinding.first.reviewStatus == 'Pending'
            ? pendingReviewContainer(context, doctorController)
            : absentReviewContainer(context, doctorController)),
  );
}

Container pendingReviewContainer(
    BuildContext context, DoctorController doctorController) {
  final review = doctorController.reviewPinding.first;

  return Container(
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
        // Displaying the service name and details
        DashboardText.reviewText(
          "Please rate your experience with '${review.serviceTitle}' by '${review.vendorName}' to help us improve.",
        ),
        10.0.kH,
        Row(
          children: [
            DashboardText.reviewSecText('On'),
            DashboardText.reviewThText('${review.bookedDate} '),
            DashboardText.reviewSecText(' at '),
            DashboardText.reviewThText(review.bookedTime)
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
                  doctorController.postReview(review.reviewId, 'Done');
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
  );
}

Container absentReviewContainer(
    BuildContext context, DoctorController doctorController) {
  final review = doctorController.reviewPinding.first;

  return Container(
    padding: const EdgeInsets.all(20),
    width: context.screenWidth * .8,
    height: doctorController.isAbsent.value
        ? context.screenHeight * .45
        : context.screenHeight * .25,
    decoration: BoxDecoration(
      color: AppTheme.lightAppColors.background,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        10.0.kH,
        DashboardText.reviewText(
          "Did you attend your appointment for '${doctorController.reviewPinding.first.serviceTitle}' by '${doctorController.reviewPinding.first.vendorName}'?",
        ),
        10.0.kH,
        Row(
          children: [
            DashboardText.reviewSecText('On '),
            DashboardText.reviewThText('${review.bookedDate} '),
            DashboardText.reviewSecText(' at '),
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
                        if (doctorController.messageController.text.isEmpty ||
                            doctorController.serviceImage.value == '') {
                          null;
                        } else {
                          doctorController.postReview(review.reviewId, 'Done');
                        }
                      },
                      title: 'Yes',
                    ),
                  ),
                  SizedBox(
                    width: context.screenWidth * .32,
                    child: AppButton(
                      onTap: () {
                        doctorController.isAbsent.value = true;
                      },
                      title: 'No',
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
                  const Text(
                    "let us know the reason below",
                    style: TextStyle(fontSize: 14),
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
                                review.reviewId, "No-show");
                          },
                          title: 'Submit',
                        ),
                      ),
                      SizedBox(
                        width: context.screenWidth * .32,
                        child: AppButton(
                          onTap: () {
                            doctorController.postReview(
                                review.reviewId, "Pending");
                          },
                          title: 'Attended',
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
