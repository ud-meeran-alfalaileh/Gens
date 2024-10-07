import 'dart:convert';

import 'package:gens/src/core/api/api_services.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/injection_container.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/fav_page/model/fav_vendor_model.dart';
import 'package:get/get.dart';

class FavController extends GetxController {
  User user = User();
  RxBool isLoading = false.obs;
  @override
  void onInit() async {
    // timeSlots = generateTimeSlots();
    await user.loadToken();
    await getFavDoctor();
    super.onInit();
  }

  final DioConsumer dioConsumer = sl<DioConsumer>();

  RxList<FavVendorModel> favDoctor = <FavVendorModel>[].obs;

  Future<void> getFavDoctor() async {
    isLoading.value = true;
    final response = await dioConsumer.get(
      "${EndPoints.getAllFav}${user.userId}",
    );

    if (response.statusCode == StatusCode.ok) {
      isLoading.value = false;
      final List<dynamic> jsonData = json.decode(response.data);

      favDoctor.value =
          jsonData.map((json) => FavVendorModel.fromJson(json)).toList();
    }
  }
}
