import 'package:flutter/material.dart';
import 'package:gens/src/feature/login/view/pages/login_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpalshController extends GetxController {
  final RxInt currentPageIndex = 0.obs;
  final PageController pageController = PageController();

  late RxBool isFirstTime = true.obs; // Initialize with a default value

  @override
  void onInit() {
    super.onInit();
    checkFirstTime(); // Call the method in onInit
  }

  Future<void> checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isFirstTimee = prefs.getBool('isFirstTime');

    // Handle the null case
    isFirstTime.value = isFirstTimee!;
  
    // To verify the value of isFirstTime
  }

  Future<void> completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    isFirstTime.value = false;
  }

  double get progress => currentPageIndex.value / 2;

  void nextPage() {
    if (currentPageIndex.value < 2) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      completeOnboarding();
      Get.offAll(const LoginPage());
    }
  }

  Color getIconColor(int currentIndex) {
    if (currentIndex == 0) {
      return const Color(0xffF2D478);
    } else if (currentIndex == 1) {
      return const Color(0xffB7ABFC);
    } else if (currentIndex == 2) {
      return const Color(0xff95B6FF);
    } else {
      return const Color(0xffffffff);
    }
  }
}
