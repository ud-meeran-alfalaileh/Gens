import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  RxInt selectedIndex = 0.obs;
  final searchController = TextEditingController();

  void setSelectedIndex(int index) {
    selectedIndex.value = index;
  }
}
