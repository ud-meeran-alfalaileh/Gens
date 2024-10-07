import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/waiting_list/controller/waiting_list_controller.dart';
import 'package:get/get.dart';

waitingHourContainer(BuildContext context, WaitingListController controller) {
  return AlignedGridView.count(
    physics: const NeverScrollableScrollPhysics(),
    crossAxisCount: 3,
    shrinkWrap: true,
    itemCount: controller.workingHours.length,
    itemBuilder: (context, index) {
      return Obx(
        () => GestureDetector(
          onTap: () {
            controller.hourSelected.value = controller
                .workingHours[index]; // Format the time with seconds set to 00
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightAppColors.black.withOpacity(0.1),
                  spreadRadius: 1.5,
                  blurRadius: 10,
                  offset: const Offset(0, 1),
                ),
              ],
              color: controller.hourSelected.value ==
                      controller.workingHours[index]
                  ? AppTheme.lightAppColors.primary
                  : AppTheme.lightAppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                controller.workingHours[index], // Display time as HH:mm:00
                style: TextStyle(
                    color: controller.hourSelected.value ==
                            controller.workingHours[index]
                        ? AppTheme.lightAppColors.maincolor
                        : AppTheme.lightAppColors.primary,
                    fontSize: 15),
              ),
            ),
          ),
        ),
      );
    },
    mainAxisSpacing: 8.0,
    crossAxisSpacing: 8.0,
  );
}
