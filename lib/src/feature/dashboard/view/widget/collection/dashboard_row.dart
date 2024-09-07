import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/feature/dashboard/controller/dashboard_controller.dart';
import 'package:gens/src/feature/dashboard/model/dashboard_filter_model.dart';
import 'package:gens/src/feature/dashboard/view/widget/collection/profile_containers.dart';
import 'package:get/get.dart';

SingleChildScrollView dashboardContainerRow(DashboardController controller) {
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
                  controller.setSelectedIndex(0);
                },
                isSelected: controller.selectedIndex.value == 0,
                title: "All"),
          ),
          20.0.kW,
          DashboardContainer(
            model: DashboardFilterModel(
                onTap: () {
                  controller.setSelectedIndex(1);
                },
                isSelected: controller.selectedIndex.value == 1,
                title: "Centers"),
          ),
          20.0.kW,
          DashboardContainer(
            model: DashboardFilterModel(
                onTap: () {
                  controller.setSelectedIndex(2);
                },
                isSelected: controller.selectedIndex.value == 2,
                title: "Freelancer"),
          ),
          20.0.kW,
          DashboardContainer(
            model: DashboardFilterModel(
                onTap: () {
                  controller.setSelectedIndex(3);
                },
                isSelected: controller.selectedIndex.value == 3,
                title: "persons"),
          ),
          20.0.kW,
          DashboardContainer(
            model: DashboardFilterModel(
                onTap: () {
                  controller.setSelectedIndex(4);
                },
                isSelected: controller.selectedIndex.value == 4,
                title: "Freelancer"),
          ),
          20.0.kW,
          DashboardContainer(
            model: DashboardFilterModel(
                onTap: () {
                  controller.setSelectedIndex(5);
                },
                isSelected: controller.selectedIndex.value == 5,
                title: "person"),
          ),
          20.0.kW,
          DashboardContainer(
            model: DashboardFilterModel(
                onTap: () {
                  controller.setSelectedIndex(6);
                },
                isSelected: controller.selectedIndex.value == 6,
                title: "persons"),
          ),
          20.0.kW,
        ],
      ),
    ),
  );
}
