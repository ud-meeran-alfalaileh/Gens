import 'dart:convert';

import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/fav_page/model/fav_vendor_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

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

  RxList<FavVendorModel> favDoctor = <FavVendorModel>[].obs;

  Future<void> getFavDoctor() async {
    isLoading.value = true;
    final response = await http.get(
      Uri.parse("${EndPoints.getAllFav}${user.userId}"),
      headers: {
        'Content-Type':
            'application/json', // This should match the API's expected content type
        'Accept': 'application/json',
      },
    );
    print("${EndPoints.getAllFav}${user.userId}");

    print(response.body);
    if (response.statusCode == StatusCode.ok) {
      isLoading.value = false;
      final List<dynamic> jsonData = json.decode(response.body);

      favDoctor.value =
          jsonData.map((json) => FavVendorModel.fromJson(json)).toList();
      print(favDoctor.length);
    }
  }
}
