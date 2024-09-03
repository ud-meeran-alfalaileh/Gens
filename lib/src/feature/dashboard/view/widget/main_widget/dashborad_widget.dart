import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/feature/dashboard/controller/dashboard_controller.dart';
import 'package:gens/src/feature/dashboard/view/widget/collection/dashboard_doctor_container.dart';
import 'package:gens/src/feature/dashboard/view/widget/collection/dashboard_row.dart';
import 'package:gens/src/feature/dashboard/view/widget/text/dashboard_text.dart';
import 'package:gens/src/feature/doctor_profile/controller/doctor_controller.dart';
import 'package:gens/src/feature/history/view/widget/collection/search_form.dart';
import 'package:get/get.dart';

class DashboradWidget extends StatelessWidget {
  const DashboradWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    final doctorController = Get.put(DoctorController());
    return SizedBox(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            pinned: false,
            backgroundColor: Colors.transparent,
            expandedHeight: context.screenHeight * .1,
            flexibleSpace: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
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
                                  left:
                                      Get.locale?.languageCode == "en" ? 20 : 0,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  DashboardText.secText("founds".tr),
                                  DashboardText.thirdText("defult"),
                                ],
                              ),
                            ),
                            SizedBox(
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
                                      return doctorDashboardContainer(context,
                                          doctorController.doctors[index]);
                                    },
                                    separatorBuilder: (context, iindex) {
                                      return 20.0.kH;
                                    },
                                    itemCount:
                                        doctorController.doctors.length)),
                          ],
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ListView.separated(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(
                                  top: 10, left: 20, right: 20, bottom: 90),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return doctorDashboardContainer(
                                    context, doctorController.doctors[index]);
                              },
                              separatorBuilder: (context, iindex) {
                                return 20.0.kH;
                              },
                              itemCount: doctorController.doctors.length)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
