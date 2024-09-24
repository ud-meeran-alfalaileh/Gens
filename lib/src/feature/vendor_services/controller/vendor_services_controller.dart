import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/core/utils/snack_bar.dart';
import 'package:gens/src/feature/doctor_profile/model/service_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class VendorServicesController extends GetxController {
  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());
  RxList<Services> services = <Services>[].obs;
  User user = User();
  final ImagePicker _picker = ImagePicker();

  final title = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  final imageUrl = TextEditingController();
  RxString serviceImage = "".obs;
  RxBool isUpdating = false.obs;

  Future<void> pickImages(context) async {
    final XFile? selectedImages =
        await _picker.pickImage(source: ImageSource.gallery);
    isUpdating.value = true;

    await uploadImageToFirebase(File(selectedImages!.path), context);

    isUpdating.value = false;

    // imageFiles.value = (File(selectedImages.take(3)).toList());
  }

  Future<String?> uploadImageToFirebase(File pickedFile, context) async {
    try {
      // Create a reference to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('sevices_image/${pickedFile.path.split('/').last}');

      await storageRef.putFile(pickedFile);

      // Get download URL
      String downloadURL = await storageRef.getDownloadURL();

      serviceImage.value = downloadURL;
      // await updateUserImage(downloadURL, context);
      isUpdating.value = false;

      return downloadURL;
    } catch (e) {
      if (kDebugMode) {
        print("Error uploading image: $e");
      }
      isUpdating.value = false;

      return null;
    }
  }

  get todayVendorBooking => null;

  @override
  void onInit() async {
    await user.loadVendorId();
    super.onInit();
  }

  Future<void> getVendorServices() async {
    if (await networkInfo.isConnected) {
      try {
        isUpdating.value = true;
        final response = await http.get(
          Uri.parse('${EndPoints.getVendorServices}/${user.vendorId}/all'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        );
        if (response.statusCode == StatusCode.ok) {
          try {
            final jsonData = json.decode(response.body);

            // Cast jsonData to List to use map properly
            List<Services> servicesData = (jsonData as List)
                .map((item) => Services.fromJson(item))
                .toList();

            services.value = servicesData;
          } catch (e) {
            Get.snackbar(
              "Error",
              "Failed to parse vendor data",
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        } else {
          Get.snackbar(
            "Error",
            "Failed to fetch vendors",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        print("Error while getting vendor services $e");
      }
    }
    isUpdating.value = false;
  }

  Future<void> setServiceData(Services service) async {
    title.text = service.title;
    description.text = service.description;
    price.text = service.price.toString();
    imageUrl.text = service.imageUrl;
    serviceImage.value = service.imageUrl;
  }

  Future<void> clearServiceData() async {
    title.clear();
    description.clear();
    price.clear();
    imageUrl.clear();
    serviceImage.value = '';
  }

  Future<void> updateService(serviceId) async {
    if (await networkInfo.isConnected) {
      try {
        var body = jsonEncode({
          "serviceId": serviceId,
          "vendorId": user.vendorId.value,
          "title": title.text.trim(),
          "description": description.text.trim(),
          "price": double.parse(price.text.trim()),
          "imageUrl": serviceImage.value,
          "isVisible": true
        });

        final response = await http.put(
            Uri.parse('${EndPoints.ediSvendorServices}/$serviceId'),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: body);

        if (response.statusCode == StatusCode.ok) {
          Get.back();
          showSnackBar(
              "Success", "Service Updated Successfully ", Colors.green);
          await Future.delayed(const Duration(seconds: 1));
          await getVendorServices();
          clearServiceData();
        } else {
          Get.snackbar(
            "Error",
            "Failed to fetch vendors",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  Future<void> deleteService(int serviceId) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await http.delete(
          Uri.parse('${EndPoints.ediSvendorServices}/$serviceId'),
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == StatusCode.noContent) {
          Get.back();
          showSnackBar(
              "Success", "Service Deleted Successfully ", Colors.green);
          await Future.delayed(const Duration(seconds: 1));
          await getVendorServices();

          clearServiceData();
        } else {
          Get.snackbar(
            "Error",
            "Failed to fetch vendors",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  Future<void> addService() async {
    if (await networkInfo.isConnected) {
      isUpdating.value = true;
      try {
        var body = jsonEncode({
          "vendorId": user.vendorId.value,
          "title": title.text.trim(),
          "description": description.text.trim(),
          "price": double.parse(price.text.trim()),
          "imageUrl": serviceImage.value
        });
        final response =
            await http.post(Uri.parse(EndPoints.ediSvendorServices),
                headers: {
                  'Accept': 'application/json',
                  'Content-Type': 'application/json',
                },
                body: body);
        if (response.statusCode == StatusCode.created) {
          try {
            Get.back();
            showSnackBar("Success", "Service Add Successfully ", Colors.green);
            await Future.delayed(const Duration(seconds: 1));
            await getVendorServices();

            clearServiceData();
            isUpdating.value = false;
          } catch (e) {
            Get.snackbar(
              "Error",
              '$e',
              snackPosition: SnackPosition.BOTTOM,
            );
            isUpdating.value = false;
          }
        } else {
          Get.snackbar(
            "Error",
            "Failed to fetch vendors",
            snackPosition: SnackPosition.BOTTOM,
          );
          isUpdating.value = false;
        }
      } catch (e) {
        isUpdating.value = false;
      }
    }
  }
}
