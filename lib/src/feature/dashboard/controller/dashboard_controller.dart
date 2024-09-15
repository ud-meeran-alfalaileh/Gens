import 'package:flutter/material.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/user.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class DashboardController extends GetxController {
  RxInt selectedIndex = 0.obs;
  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());
  final searchController = TextEditingController();
  RxString searchValue = ''.obs;
  User user = User();
  @override
  void onInit() {
    user.loadToken();
    super.onInit();
  }

  void setSelectedIndex(int index) {
    selectedIndex.value = index;
  }
}
