import 'package:flutter/material.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/utils/loading_page.dart';
import 'package:gens/src/feature/profile/view/widget/text/profile_text.dart';
import 'package:gens/src/feature/show_user/view/page/show_user_page.dart';
import 'package:gens/src/feature/vendor_profile/controller/vendor_profile_controller.dart';
import 'package:get/get.dart';

class AllPatientWidget extends StatefulWidget {
  const AllPatientWidget({super.key});

  @override
  State<AllPatientWidget> createState() => _AllPatientWidgetState();
}

class _AllPatientWidgetState extends State<AllPatientWidget> {
  final controller = Get.put(VendorProfileController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mainMethod();
    });

    // Add listener to the search controller
  }

  Future<void> mainMethod() async {
    controller.isLoading.value = true;
    await controller.getVendorPatient();
    controller.isLoading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightAppColors.background,
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? loadingPage(context)
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_new_outlined,
                              color: AppTheme.lightAppColors.primary,
                            ),
                          ),
                          const Spacer(),
                          ProfileText.mainText("Patient List".tr),
                          const Spacer(),
                          40.0.kW,
                        ],
                      ),
                      20.0.kH,
                      // SearchForm(
                      //   search: SearchFormEntitiy(
                      //     searchController: controller.searchController,
                      //     hintText: "Search Here",
                      //     type: TextInputType.text,
                      //     ontap: () {},
                      //     enableText: F,
                      //     onChange: (dd) {},
                      //   ),
                      // ),
                      20.0.kH,
                      Obx(
                        () => ListView.separated(
                          shrinkWrap: true,
                          itemCount: controller.patient.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return 20.0.kH;
                          },
                          itemBuilder: (BuildContext context, int index) {
                            final patient = controller.patient[index];
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => ShowUserPage(id: patient.userId));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppTheme
                                        .lightAppColors.secondaryColor
                                        .withOpacity(0.2),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor:
                                          AppTheme.lightAppColors.background,
                                      backgroundImage:
                                          NetworkImage(patient.userImage ?? ''),
                                    ),
                                    10.0.kW,
                                    Text(patient.userFName),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        controller
                                            .makePhoneCall(patient.phoneNumber);
                                      },
                                      icon: Icon(
                                        Icons.phone,
                                        color: AppTheme
                                            .lightAppColors.secondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
