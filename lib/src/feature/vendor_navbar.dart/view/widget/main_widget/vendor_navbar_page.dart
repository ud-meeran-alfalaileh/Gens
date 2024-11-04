import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/login/view/pages/login_page.dart';
import 'package:gens/src/feature/nav_bar/controller/nav_bar_controller.dart';
import 'package:gens/src/feature/nav_bar/view/partial_widget/custome_navbar.dart';
import 'package:gens/src/feature/test.dart';
import 'package:gens/src/feature/vendor_calendar/view/page/vendor_calendar.dart';
import 'package:gens/src/feature/vendor_profile/view/page/vendor_profile_page.dart';
import 'package:gens/src/feature/vendor_services/view/page/vendor_service.dart';
import 'package:get/get.dart';

class VendorNavBar extends StatefulWidget {
  const VendorNavBar({super.key});

  @override
  State<VendorNavBar> createState() => _VendorNavBarState();
}

class _VendorNavBarState extends State<VendorNavBar> {
  final NavController controller = Get.put(NavController());
  User user = User();

  @override
  void initState() {
    controller.isLoading.value = true;
    initialState();

    super.initState();
  }

  Future<void> initialState() async {
    await user.loadToken();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selectedIndex(0);

      // controller.getVendorsWorkingTime();
    });
    await controller.getVendorsById();

    // await user.loadVendorId();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.status.value == false
        ? Scaffold(
            backgroundColor: AppTheme.lightAppColors.background,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RotatingImage(),
                  20.0.kH,
                  Text(
                    "waitingVendor".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: AppTheme.lightAppColors.primary,
                        fontSize: 30,
                        fontWeight: FontWeight.w700),
                  ),
                  20.0.kH,
                  GestureDetector(
                    onTap: () {
                      controller.logout();
                    },
                    child: Text(
                      "logout".tr,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppTheme.lightAppColors.mainTextcolor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                  )
                ],
              ),
            ),
          )
        : FutureBuilder(
            future: user.loadToken(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Container(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: LoginPage(),
                );
              } else {
                if (user.vendorId.value == 0) {
                  return const LoginPage();
                } else {
                  return Obx(() {
                    return Scaffold(
                      body: Stack(
                        children: [
                          Obx(() {
                            switch (controller.selectedIndex.value) {
                              case 0:
                                return const VendorCalendar();
                              case 1:
                                return const VendorServicePage();

                              case 2:
                                return const VendorCalendar();
                              case 3:
                                return const VendorProfilePage();

                              default:
                                return const Scaffold();
                            }
                          }),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              height: 90,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      height: 80,
                                      // padding: const EdgeInsets.only(top: 2),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            const BorderRadius.vertical(
                                                top: Radius.circular(30)),
                                        border: Border.all(
                                            color: AppTheme
                                                .lightAppColors.primary
                                                .withOpacity(0.1)),
                                        color:
                                            AppTheme.lightAppColors.background,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: <Widget>[
                                          CustomNavItem(
                                            icon: Container(
                                              width: 50,
                                              height: 50,
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: controller
                                                              .selectedIndex
                                                              .value ==
                                                          0
                                                      ? AppTheme.lightAppColors
                                                          .maincolor
                                                      : AppTheme.lightAppColors
                                                          .background),
                                              child: Center(
                                                child: ColorFiltered(
                                                  colorFilter: ColorFilter.mode(
                                                    controller.selectedIndex
                                                                .value ==
                                                            0
                                                        ? AppTheme
                                                            .lightAppColors
                                                            .primary
                                                        : AppTheme
                                                            .lightAppColors
                                                            .mainTextcolor
                                                            .withOpacity(.9),
                                                    BlendMode.srcIn,
                                                  ),
                                                  child: SvgPicture.asset(
                                                    'assets/image/Home.svg',
                                                    width: 30,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              controller.setSelectedIndex(0);
                                            },
                                            isSelected: controller
                                                    .selectedIndex.value ==
                                                0,
                                            title: ' ',
                                          ),
                                          CustomNavItem(
                                            icon: Container(
                                              width: 50,
                                              height: 50,
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: controller
                                                              .selectedIndex
                                                              .value ==
                                                          1
                                                      ? AppTheme.lightAppColors
                                                          .maincolor
                                                      : AppTheme.lightAppColors
                                                          .background),
                                              child: Center(
                                                child: ColorFiltered(
                                                  colorFilter: ColorFilter.mode(
                                                    controller.selectedIndex
                                                                .value ==
                                                            1
                                                        ? AppTheme
                                                            .lightAppColors
                                                            .primary
                                                        : AppTheme
                                                            .lightAppColors
                                                            .mainTextcolor
                                                            .withOpacity(.9),
                                                    BlendMode.srcIn,
                                                  ),
                                                  child: Image.asset(
                                                    'assets/image/add.png',
                                                    height: 23,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              controller.setSelectedIndex(1);
                                            },
                                            isSelected: controller
                                                    .selectedIndex.value ==
                                                1,
                                            title: '',
                                          ),
                                          CustomNavItem(
                                            icon: Container(
                                              width: 50,
                                              height: 50,
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: controller
                                                              .selectedIndex
                                                              .value ==
                                                          2
                                                      ? AppTheme.lightAppColors
                                                          .maincolor
                                                      : AppTheme.lightAppColors
                                                          .background),
                                              child: Center(
                                                child: ColorFiltered(
                                                  colorFilter: ColorFilter.mode(
                                                    controller.selectedIndex
                                                                .value ==
                                                            2
                                                        ? AppTheme
                                                            .lightAppColors
                                                            .primary
                                                        : AppTheme
                                                            .lightAppColors
                                                            .mainTextcolor
                                                            .withOpacity(.9),
                                                    BlendMode.srcIn,
                                                  ),
                                                  child: Image.asset(
                                                    'assets/image/calendar.png',
                                                    height: 23,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              controller.setSelectedIndex(2);
                                            },
                                            isSelected: controller
                                                    .selectedIndex.value ==
                                                2,
                                            title: '',
                                          ),
                                          CustomNavItem(
                                            icon: Container(
                                              width: 50,
                                              height: 50,
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: controller
                                                              .selectedIndex
                                                              .value ==
                                                          3
                                                      ? AppTheme.lightAppColors
                                                          .maincolor
                                                      : AppTheme.lightAppColors
                                                          .background),
                                              child: Center(
                                                child: ColorFiltered(
                                                  colorFilter: ColorFilter.mode(
                                                    controller.selectedIndex
                                                                .value ==
                                                            3
                                                        ? AppTheme
                                                            .lightAppColors
                                                            .primary
                                                        : AppTheme
                                                            .lightAppColors
                                                            .mainTextcolor
                                                            .withOpacity(.9),
                                                    BlendMode.srcIn,
                                                  ),
                                                  child: SvgPicture.asset(
                                                    'assets/image/Profiel.svg',
                                                    width: 30,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            onTap: () {
                                              controller.setSelectedIndex(3);
                                            },
                                            isSelected: controller
                                                    .selectedIndex.value ==
                                                2,
                                            title: ' ',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
                }
              }
            },
          ));
  }
}
