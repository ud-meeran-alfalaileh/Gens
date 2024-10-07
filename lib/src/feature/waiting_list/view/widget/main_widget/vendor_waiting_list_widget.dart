import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/sizes/sizes.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/feature/doctor_profile/view/widget/text/doctor_text.dart';
import 'package:gens/src/feature/vendor_dashboard/controller/vendor_dashboard_controoler.dart';
import 'package:gens/src/feature/waiting_list/model/waiting_list_model.dart';
import 'package:gens/src/feature/waiting_list/view/widget/text/waiting_list_text.dart';
import 'package:get/get.dart';

class VendorWaitingListWidget extends StatelessWidget {
  const VendorWaitingListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VendorDashboardController());
    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: AppTheme.lightAppColors.black.withOpacity(.8),
                  )),
              const Spacer(),
              DoctorText.mainText("Waiting list"),
              const Spacer(),
              (30.0).kW,
            ],
          ),
          Expanded(
            child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return _buildWaitingListContainer(context, controller, index);
                },
                separatorBuilder: (context, index) {
                  return 20.0.kH;
                },
                itemCount: controller.waitingList.length),
          )
        ],
      ),
    );
  }

  Container _buildWaitingListContainer(
      BuildContext context, VendorDashboardController controller, int index) {
    RxBool statusUpadating = false.obs;
    return Container(
      padding: const EdgeInsets.all(15),
      width: context.screenWidth,
      decoration: BoxDecoration(
          border: Border.all(color: AppTheme.lightAppColors.maincolor),
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
      child: Column(
        children: [
          Row(
            children: [
              WaitingListText.mainText(controller.waitingList[index].userName),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    controller.makePhoneCall(
                        controller.waitingList[index].userPhoneNumber);
                  },
                  icon: Icon(
                    Icons.phone,
                    color: AppTheme.lightAppColors.primary,
                  )),
            ],
          ),
          const Divider(),
          Row(
            children: [
              WaitingListText.thirdText("Date Range"),
              Spacer(),
              WaitingListText.thirdText(
                  controller.waitingList[index].startDate),
              WaitingListText.thirdText(" To "),
              WaitingListText.thirdText(controller.waitingList[index].endDate),
            ],
          ),
          10.0.kH,
          Row(
            children: [
              WaitingListText.thirdText("Time Range"),
              const Spacer(),
              WaitingListText.thirdText(
                  controller.waitingList[index].startTime),
              WaitingListText.thirdText(" To "),
              Text(controller.waitingList[index].endTime),
            ],
          ),
          10.0.kH,
          Obx(
            () => statusUpadating.value
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.lightAppColors.primary,
                      ),
                    ),
                  )
                : controller.waitingList[index].status == "Accept"
                    ? Text('done')
                    : controller.waitingList[index].status == "Reject"
                        ? Text('Reject')
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              statusWidget(
                                  controller.waitingList[index],
                                  statusUpadating,
                                  context,
                                  'Accept',
                                  'accept',
                                  controller),
                              10.0.kW,
                              statusWidget(
                                  controller.waitingList[index],
                                  statusUpadating,
                                  context,
                                  'Reject',
                                  'reject',
                                  controller)
                            ],
                          ),
          )
        ],
      ),
    );
  }

  GestureDetector statusWidget(
      WaitingListModel model,
      RxBool statusUpadating,
      BuildContext context,
      status,
      title,
      VendorDashboardController controller) {
    return GestureDetector(
      onTap: () {
        controller.updateWaitingStatus(
            status, model.id, model, statusUpadating);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: context.screenHeight * .04,
        decoration: BoxDecoration(
            color: model.status == "Done"
                ? Colors.green
                : status == "Waiting"
                    ? AppTheme.lightAppColors.bordercolor
                    : AppTheme.lightAppColors.primary,
            borderRadius: BorderRadius.circular(20)),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: AppTheme.lightAppColors.background,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }
}
