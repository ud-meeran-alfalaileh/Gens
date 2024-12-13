import 'package:flutter/material.dart';
import 'package:gens/src/feature/nav_bar/view/main/navbar_page.dart';
import 'package:gens/src/feature/splash_screens/controller/spalsh_controller.dart';
import 'package:gens/src/feature/splash_screens/view/pages/spalsh_page.dart';
import 'package:get/get.dart';

class MainAppPage extends StatefulWidget {
  const MainAppPage({super.key});

  @override
  State<MainAppPage> createState() => _MainAppPageState();
}

class _MainAppPageState extends State<MainAppPage> {
  final controller = Get.put(SpalshController());

  @override
  void initState() {
    super.initState();
    controller
        .checkFirstTime(); // Ensure this is called to set the value initially
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isFirstTime.value) {
        return const SpalshPage();
      } else {
        return const NavBarPage(
          currentScreen: 0,
        );
      }
    });
  }
}
