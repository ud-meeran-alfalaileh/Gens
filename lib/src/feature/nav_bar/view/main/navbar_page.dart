import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gens/src/config/sizes/size_box_extension.dart';
import 'package:gens/src/config/theme/theme.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/login/view/pages/login_page.dart';
import 'package:gens/src/feature/nav_bar/controller/nav_bar_controller.dart';
import 'package:gens/src/feature/nav_bar/view/partial_widget/custome_navbar.dart';

class NavBarPage extends StatefulWidget {
  const NavBarPage({super.key});

  @override
  State<NavBarPage> createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  final NavController controller = Get.put(NavController());
  User user = User();

  @override
  void initState() {
    controller.selectedIndex(0);
    initialState();
    super.initState();
  }

  Future<void> initialState() async {
    await user.loadToken();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
          if (user.token.value.isEmpty) {
            return const LoginPage();
          } else {
            return Obx(() {
              return Scaffold(
                body: Stack(
                  children: [
                    Obx(() {
                      switch (controller.selectedIndex.value) {
                        case 0:
                          return const Scaffold();
                        case 1:
                          return const Scaffold();

                        case 2:
                          return const Scaffold();

                        case 3:
                          return const Scaffold();

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
                                padding: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(50)),
                                  color: AppTheme.lightAppColors.background,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    CustomNavItem(
                                      icon: ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                          controller.selectedIndex.value == 0
                                              ? AppTheme
                                                  .lightAppColors.thirdTextcolor
                                              : AppTheme
                                                  .lightAppColors.mainTextcolor
                                                  .withOpacity(.9),
                                          BlendMode.srcIn,
                                        ),
                                        child: Image.asset(
                                          'assets/icon/Home.png',
                                          height: 22,
                                        ),
                                      ),
                                      onTap: () {
                                        controller.setSelectedIndex(0);
                                      },
                                      isSelected:
                                          controller.selectedIndex.value == 0,
                                      title: ' ',
                                    ),
                                    CustomNavItem(
                                      icon: ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                          controller.selectedIndex.value == 1
                                              ? AppTheme
                                                  .lightAppColors.thirdTextcolor
                                              : AppTheme
                                                  .lightAppColors.mainTextcolor
                                                  .withOpacity(.9),
                                          BlendMode.srcIn,
                                        ),
                                        child: Image.asset(
                                          'assets/icon/History.png',
                                          height: 23,
                                        ),
                                      ),
                                      onTap: () {
                                        controller.setSelectedIndex(1);
                                      },
                                      isSelected:
                                          controller.selectedIndex.value == 1,
                                      title: '',
                                    ),
                                    (50.0).kW,
                                    CustomNavItem(
                                      icon: ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                          controller.selectedIndex.value == 2
                                              ? AppTheme
                                                  .lightAppColors.thirdTextcolor
                                              : AppTheme
                                                  .lightAppColors.mainTextcolor
                                                  .withOpacity(.9),
                                          BlendMode.srcIn,
                                        ),
                                        child: Image.asset(
                                          'assets/icon/User.png',
                                          width: 22,
                                        ),
                                      ),
                                      onTap: () {
                                        controller.setSelectedIndex(2);
                                      },
                                      isSelected:
                                          controller.selectedIndex.value == 2,
                                      title: ' ',
                                    ),
                                    CustomNavItem(
                                      icon: ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                          controller.selectedIndex.value == 3
                                              ? AppTheme
                                                  .lightAppColors.thirdTextcolor
                                              : AppTheme
                                                  .lightAppColors.mainTextcolor
                                                  .withOpacity(.9),
                                          BlendMode.srcIn,
                                        ),
                                        child: Image.asset(
                                          'assets/icon/Settings.png',
                                          width: 28,
                                        ),
                                      ),
                                      onTap: () {
                                        controller.setSelectedIndex(3);
                                      },
                                      isSelected:
                                          controller.selectedIndex.value == 3,
                                      title: 'Favorite',
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
    );
  }
}
