import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gens/src/config/sizes/short_text.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/loading_page.dart';
import 'package:gens/src/feature/dashboard/view/widget/text/dashboard_text.dart';
import 'package:gens/src/feature/doctor_profile/view/page/doctor_page.dart';
import 'package:gens/src/feature/fav_page/fav_controller.dart';
import 'package:gens/src/feature/fav_page/model/fav_vendor_model.dart';
import 'package:gens/src/feature/vendor_dashboard/view/widget/text/vendor_dashboard_text.dart';
import 'package:get/get.dart';

class FavWidget extends StatefulWidget {
  const FavWidget({super.key});

  @override
  State<FavWidget> createState() => _FavWidgetState();
}

class _FavWidgetState extends State<FavWidget> {
  final controller = Get.put(FavController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value
          ? loadingPage(context)
          : SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: AppTheme.lightAppColors.primary,
                          )),
                      const Spacer(),
                      Text(
                        "Favorites",
                        style: TextStyle(
                            fontFamily: "Inter",
                            color: AppTheme.lightAppColors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      36.0.kW,
                    ],
                  ),
                  controller.favDoctor.isEmpty
                      ? Column(
                          children: [
                            100.0.kH,
                            Image.asset(
                              'assets/image/empty-box.png',
                              width: 200,
                            ),
                            10.0.kH,
                            VendorDashboardText.emptyText(
                                "Currently, there are no favourit Items"),
                          ],
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.favDoctor.length == 1
                              ? 2
                              : controller.favDoctor.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return doctorDashboardContainer(context,
                                controller.favDoctor[index], controller);
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return 10.0.kH;
                          },
                        ),
                ],
              ),
            ),
    );
  }

  doctorDashboardContainer(
    BuildContext context,
    FavVendorModel model,
    FavController controller,
  ) {
    return GestureDetector(
      onTap: () {
        Get.to(() => DoctorPage(
              model: model.vendorId,
              type: 'Fav',
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: context.screenWidth,
        decoration: BoxDecoration(
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                    image: model.businessImage.isEmpty ||
                            model.businessImage == 'string'
                        ? const AssetImage("assets/image/AppLogo (1).png")
                        : NetworkImage(model.businessImage),
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter),
              ),
            ),
            10.0.kW,
            SizedBox(
              width: 190,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DashboardText.mainText(vendorShortText(model.vendorName)),
                    ],
                  ),
                  7.0.kH,
                  Container(
                    width: context.screenWidth * .45,
                    decoration: BoxDecoration(
                        color: AppTheme.lightAppColors.subTextcolor,
                        border: Border.all(
                            color: AppTheme.lightAppColors.bordercolor,
                            width: .5)),
                  ),
                  7.0.kH,
                  DashboardText.typeText(model.vendorName),
                  10.0.kH,
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 20,
                        color: AppTheme.lightAppColors.black.withOpacity(0.5),
                      ),
                      // 5.0.kW,
                      DashboardText.locationText(
                          locationShortText(model.address))
                    ],
                  ),
                  10.0.kH,
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/image/ratingStar.svg",
                        color: AppTheme.lightAppColors.secondaryColor,
                        height: 15,
                      ),
                      10.0.kW,
                      DashboardText.ratingText(model.reviewCount.toString()),
                      15.0.kW,
                      Container(
                        width: 2,
                        height: 30,
                        color: AppTheme.lightAppColors.bordercolor,
                      ),
                      15.0.kW,
                      DashboardText.ratingText(
                          "${model.reviewCount.toString()} Reviews"),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
