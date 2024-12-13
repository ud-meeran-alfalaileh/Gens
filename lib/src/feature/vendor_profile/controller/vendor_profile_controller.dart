import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:gens/src/core/api/api_services.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/injection_container.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/core/utils/snack_bar.dart';
import 'package:gens/src/feature/doctor_profile/model/doctor_model.dart';
import 'package:gens/src/feature/vendor_profile/model/patients_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
// ignore: depend_on_referenced_packages
// For extracting filename
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class VendorProfileController extends GetxController {
  // final searchController = TextEditingController();
  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());
  final name = TextEditingController();
  final email = TextEditingController();
  final userType = TextEditingController();
  final description = TextEditingController();
  final phone = TextEditingController();
  final location = TextEditingController();
  RxInt selectedIndex = 0.obs;
  final DioConsumer dioConsumer = sl<DioConsumer>();
  RxList<PatientsModel> patient = <PatientsModel>[].obs;

  final image = TextEditingController();
  Rx<DoctorModelById> vendor = DoctorModelById(
          vendorId: 1,
          name: "name",
          type: "type",
          location: 'location',
          pastBookings: 1,
          avgRating: 1,
          reviewCount: 1,
          description: "description",
          workingTime: "workingTime",
          reviews: [],
          businessImages: [
            BusinessImages(
                id: 1,
                vendorID: 1,
                imgUrl1: "imgUrl1",
                imgUrl2: "imgUrl2",
                imgUrl3: "imgUrl3",
                vendor: "vendor")
          ],
          phone: "phone")
      .obs;
  RxList<File?> updatedImages = List<File?>.filled(3, null).obs;
  RxList<String> imageUrls = <String>[].obs;
  RxBool isLoading = false.obs;
  User user = User();
  @override
  Future<void> onInit() async {
    await user.loadVendorId();

    super.onInit();
    await getVendorsById();
  }

  void setSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  Future<void> getVendorsById() async {
    isLoading.value = true;

    if (await networkInfo.isConnected) {
      try {
        final response = await dioConsumer
            .get("${EndPoints.getVendorId}/${user.vendorId}/details");
        // print("{{{{{{id}}}}}}");
        // print(user.vendorId);
        // print("{{{{{{{{id}}}}}}}}");

        if (response.statusCode == StatusCode.ok) {
          try {
            final dynamic jsonData = json.decode(response.data);

            vendor.value = DoctorModelById.fromJson(jsonData);
            name.text = vendor.value.name;
            location.text = vendor.value.location;
            // email.text = vendor.value.email;
            description.text = vendor.value.description;
            phone.text = vendor.value.phone;
            userType.text = vendor.value.type;
            image.text = vendor.value.businessImages.first.imgUrl1;
            imageUrls.clear();
            // Update the images list
            imageUrls.add(vendor.value.businessImages.first.imgUrl1);
            imageUrls.add(vendor.value.businessImages.first.imgUrl2);
            imageUrls.add(vendor.value.businessImages.first.imgUrl3);
            // vendor.value.businessImages.map((img) => img.imgUrl1).toList();
            isLoading.value = false;
          } catch (e) {
            Get.snackbar(
              "Error",
              "Failed to parse vendor data",
              snackPosition: SnackPosition.BOTTOM,
            );
          }
          isLoading.value = false;
        } else {
          Get.snackbar(
            "Error",
            "Failed to fetch vendors",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
        isLoading.value = false;
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      Get.snackbar(
        "No Internet Connection",
        "Please check your network settings",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void logout(context) async {
    await user.clearVendorId();
    OneSignal.logout();

    Phoenix.rebirth(context);
  }

  Future<void> updateUser(context) async {
    if (await networkInfo.isConnected) {
      isLoading.value = true;
      var body = jsonEncode({
        "email": email.text.trim(),
        "name": name.text.trim(),
        "address": location.text.trim(),
        "description": description.text.trim(),
        "phone": "962791368189"
      });
      try {
        final response = await http.put(
            Uri.parse(
                "https://gts-b8dycqbsc6fqd6hg.uaenorth-01.azurewebsites.net/api/Vendor/${user.vendorId.value}/basic-info"),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: body);
        if (kDebugMode) {
          print(response.body);
        }
        if (response.statusCode == StatusCode.ok) {
          isLoading.value = false;
          showSnackBar("Success", "Data Updated Successfully", Colors.green);
          // getVendorsById();
        } else {}
      } catch (e) {
        isLoading.value = false;

        if (kDebugMode) {
          print(e);
        }
      }
    } else {
      isLoading.value = false;

      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: 'No Internet Connection'.tr,
        ),
      );
    }
  }

  RxList<PatientsModel> filteredPatients = <PatientsModel>[].obs;
  Future<void> getVendorPatient() async {
    try {
      final response = await dioConsumer
          .get("${EndPoints.getBookingVendor}${user.vendorId}/patients");
      print(response.data);
      if (response.statusCode == StatusCode.ok) {
        final responseData = jsonDecode(response.data);
        patient.value = PatientsModel.fromJsonList(responseData);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    var number = phoneNumber; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  // void filterPatients(searchController) {
  //   final query = searchController.toLowerCase();
  //   if (query.isEmpty) {
  //     filteredPatients.value = patient; // Show all patients
  //   } else {
  //     filteredPatients.value = patient.where((p) {
  //       final name = p.userFName.toLowerCase();
  //       final phone = p.phoneNumber.toLowerCase();
  //       return name.contains(query) || phone.contains(query);
  //     }).toList();
  //   }
  // }
}
