import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/feature/history/view/widget/text/history_text.dart';

class HistoryWidget extends StatelessWidget {
  const HistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(HistoryController());
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
            (context.screenHeight * .06).kH,
            // SizedBox(
            //   width: context.screenWidth * .8,
            //   height: context.screenHeight * .06,
            //   child: Center(
            //     child: SizedBox(
            //       width: context.screenWidth * .8,
            //       child: SearchForm(
            //         search: SearchFormEntitiy(
            //           hintText: "Search for Product here".tr,
            //           type: TextInputType.name,
            //           ontap: () {},
            //           enableText: false,
            //           onChange: (value) {},
            //           searchController: controller.searchController,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
