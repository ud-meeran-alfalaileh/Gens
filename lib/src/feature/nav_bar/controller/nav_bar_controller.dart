import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavController extends GetxController {
  RxInt selectedIndex = 0.obs;
  final PageController pageController = PageController(initialPage: 0);
  @override
  void onInit() {
    super.onInit();

    setSelectedIndex(0);
    update();
  }

  void setSelectedIndex(int index) {
    selectedIndex.value = index;
  }
}
