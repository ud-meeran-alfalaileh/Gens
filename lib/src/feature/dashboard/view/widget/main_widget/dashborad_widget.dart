import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/feature/dashboard/controller/dashboard_controller.dart';
import 'package:gens/src/feature/dashboard/view/widget/collection/dashboard_doctor_container.dart';
import 'package:gens/src/feature/dashboard/view/widget/collection/dashboard_row.dart';
import 'package:gens/src/feature/history/view/widget/collection/search_form.dart';
import 'package:gens/src/feature/history/view/widget/text/history_text.dart';
import 'package:get/get.dart';

class DashboradWidget extends StatelessWidget {
  const DashboradWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DashboardController());
    return SizedBox(
      width: context.screenWidth,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (context.screenHeight * .06).kH,
            HistoryText.headerText("My Bookings"),
            (context.screenHeight * .03).kH,
            SearchForm(
              search: SearchFormEntitiy(
                hintText: "Search for Product here".tr,
                type: TextInputType.name,
                ontap: () {},
                enableText: false,
                onChange: (value) {},
                searchController: controller.searchController,
              ),
            ),
            (context.screenHeight * .01).kH,
            dashboardContainerRow(controller),
            doctorDashboardContainer(context),
          ],
        ),
      ),
    );
  }
}
