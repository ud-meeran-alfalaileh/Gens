import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/feature/dashboard/controller/dashboard_controller.dart';
import 'package:gens/src/feature/dashboard/model/dashboard_filter_model.dart';
import 'package:gens/src/feature/dashboard/view/widget/collection/profile_containers.dart';
import 'package:gens/src/feature/doctor_profile/controller/doctor_controller.dart';
import 'package:get/get.dart';

SingleChildScrollView dashboardContainerRow(DashboardController controller) {
  final DoctorController doctorController = Get.put(DoctorController());
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DashboardContainer(
            model: DashboardFilterModel(
                onTap: () {
                  doctorController.searchDoctorsByType("");

                  controller.setSelectedIndex(0);
                },
                isSelected: controller.selectedIndex.value == 0,
                title: "All".tr),
          ),
          20.0.kW,
          DashboardContainer(
            model: DashboardFilterModel(
                onTap: () {
                  doctorController.searchDoctorsByType("Centers");
                  controller.setSelectedIndex(1);
                },
                isSelected: controller.selectedIndex.value == 1,
                title: "Centers".tr),
          ),
          20.0.kW,
          DashboardContainer(
            model: DashboardFilterModel(
                onTap: () {
                  doctorController.searchDoctorsByType("Freelance");

                  controller.setSelectedIndex(2);
                },
                isSelected: controller.selectedIndex.value == 2,
                title: "Freelancer".tr),
          ),
          20.0.kW,
          20.0.kW,
        ],
      ),
    ),
  );
}
