import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/feature/dashboard/controller/dashboard_controller.dart';
import 'package:gens/src/feature/dashboard/view/widget/collection/dashboard_doctor_container.dart';
import 'package:gens/src/feature/dashboard/view/widget/collection/dashboard_row.dart';
import 'package:gens/src/feature/dashboard/view/widget/collection/dashboard_shimmer.dart';
import 'package:gens/src/feature/dashboard/view/widget/collection/pending_review.dart';
import 'package:gens/src/feature/dashboard/view/widget/text/dashboard_text.dart';
import 'package:gens/src/feature/doctor_profile/controller/doctor_controller.dart';
import 'package:gens/src/feature/history/view/widget/collection/search_form.dart';
import 'package:gens/src/feature/vendor_dashboard/view/widget/text/vendor_dashboard_text.dart';
import 'package:get/get.dart';

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
                    child: _buildHeader(context),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSerach(),
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
                                        DashboardText.secText("founds".tr),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    child: doctorController.isLoading.value
                                        ? dashboardShimmer()
                                        : doctorController.doctors.isEmpty
                                            ? Column(
                                                children: [
                                                  Image.asset(
                                                    'assets/image/empty-box.png',
                                                    width: context.screenWidth *
                                                        .5,
                                                  ),
                                                  VendorDashboardText.emptyText(
                                                      "errorDoctor".tr),
                                                ],
                                              )
                                            : _buildDoctorList(),
                                  )
                                ],
                              )
                            : _buildFilteredList(),
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

  Padding _buildFilteredList() {
    return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            padding:
                const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 90),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return doctorDashboardContainer(
                  context,
                  controller.searchController.text.isEmpty
                      ? doctorController.filteredDoctors[index]
                      : doctorController.filteredDoctors[index],
                  doctorController);
            },
            separatorBuilder: (context, iindex) {
              return 20.0.kH;
            },
            itemCount: doctorController.filteredDoctors.length));
  }

  ListView _buildDoctorList() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 90),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return doctorDashboardContainer(
            context, doctorController.filteredDoctors[index], doctorController);
      },
      separatorBuilder: (context, index) {
        return 20.0.kH;
      },
      itemCount: doctorController.filteredDoctors.length,
    );
  }

  Padding _buildSerach() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SearchForm(
        search: SearchFormEntitiy(
          hintText: "searchDoctor".tr,
          type: TextInputType.name,
          ontap: () {},
          enableText: false,
          onChange: (value) {
            controller.searchValue.value = controller.searchController.text;
            doctorController.searchDoctors(
                controller.searchValue.value); // Call the search method
          },
          searchController: controller.searchController,
        ),
      ),
    );
  }

  Row _buildHeader(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        Image.asset(
          "assets/image/Logo2 2.png",
          height: context.screenHeight * .032,
        ),
        const Spacer(),
        16.0.kW,
      ],
    );
  }
}
