import 'dart:convert';

import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/history/model/history_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

class VendorHistoryController extends GetxController {
  RxBool isLaoding = false.obs;

  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());

  RxList<VendorBooking> history = <VendorBooking>[].obs;
  User user = User();
  @override
  Future<void> onInit() async {
    await user.loadVendorId();
    getVendorBoooking();

    super.onInit();
  }

  Future<void> getVendorBoooking() async {
    if (await networkInfo.isConnected) {
      isLaoding.value = true;
      try {
        final response = await http.get(
          Uri.parse("${EndPoints.vendorHistory}/${user.vendorId}/History"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );
        print(user.vendorId);
        print(response.body);
        print(response.statusCode);
        if (response.statusCode == StatusCode.ok) {
          final List<dynamic> jsonData = json.decode(response.body);

          List<VendorBooking> servicesData =
              jsonData.map((json) => VendorBooking.fromJson(json)).toList();

          history.value = servicesData;

          isLaoding.value = false;
        } else {
          history.value = [];
          isLaoding.value = false;
        }
      } catch (e) {
        print(e);
        isLaoding.value = false;
      }
    } else {
      Get.snackbar(
        "No Internet Connection",
        "Please check your network settings",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
