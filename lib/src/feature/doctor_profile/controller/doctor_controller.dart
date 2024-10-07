import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gens/src/core/api/api_services.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/injection_container.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/dashboard/model/review_pending_model.dart';
import 'package:gens/src/feature/doctor_profile/model/doctor_model.dart';
import 'package:gens/src/feature/doctor_profile/model/service_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class DoctorController extends GetxController {
  var isExpanded = false.obs;
  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());
  final DioConsumer dioConsumer = sl<DioConsumer>();

  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  final ImagePicker _picker = ImagePicker();

  final imageUrl = TextEditingController();
  RxString serviceImage = "".obs;
  RxBool isUpdating = false.obs;
  RxBool addingImage = false.obs;

  RxBool isAbsent = false.obs;
  RxList<String> imagesUrl = <String>[].obs;
  RxDouble userRating = 5.0.obs; // Initial rating
  TextEditingController messageController = TextEditingController();
  User user = User();

  RxBool isLoading = false.obs;
  RxBool isLoadingVendor = false.obs;

  RxList<Vendor> doctors = <Vendor>[].obs;
  RxList<Services> services = <Services>[].obs;
  RxInt srevice = 5.obs;
  RxString sreviceDescription = "".obs;
  RxDouble servicePrice = 0.0.obs;
  RxBool showReview = false.obs;
  Rx<Favourite?> favourite = Rx<Favourite?>(null);
  RxBool isFav = false.obs;

  RxString isFavString = "".obs;

  late Rx<DoctorModelById?> doctor;
  RxList<ReviewPending> reviewPinding = <ReviewPending>[].obs;
  @override
  void onInit() {
    user.loadToken();
    getPendingReview();
    getVendors();

    doctor = DoctorModelById(
            vendorId: 0,
            name: "name",
            type: "type",
            location: "location",
            pastBookings: 0,
            avgRating: 0,
            reviewCount: 0,
            description: "description",
            reviews: [],
            businessImages: [],
            workingTime: '',
            phone: '')
        .obs;
    super.onInit();
  }

  RxList<Vendor> filteredDoctors = <Vendor>[].obs;

  void searchDoctors(String query) {
    if (query.isEmpty) {
      filteredDoctors.value = doctors;
    } else {
      filteredDoctors.value = doctors.where((vendor) {
        final nameMatches =
            vendor.name.toLowerCase().contains(query.toLowerCase());
        final locationMatches =
            vendor.address.toLowerCase().contains(query.toLowerCase());
        return nameMatches || locationMatches;
      }).toList();
    }
  }

  Future<void> addFav(vendorId) async {
    if (await networkInfo.isConnected) {
      var body = jsonEncode({
        "userId": user.userId.value,
        "vendorId": vendorId,
        "isFav": true,
      });
      final response = await dioConsumer.post(EndPoints.postFav, body: body);
      print(response);
      getFav(vendorId);
    }
  }

  Future<void> putFav(vendorId, value, favId) async {
    if (await networkInfo.isConnected) {
      try {
        var body = jsonEncode({
          "id": favId,
          "userId": user.userId.value,
          "vendorId": vendorId,
          "isFav": value,
        });

        await http.put(Uri.parse("${EndPoints.postFav}/$favId"),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: body);

        getFav(vendorId);
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  Future<void> getFav(id) async {
    try {
      final response = await dioConsumer.get(
        "${EndPoints.getFav}${user.userId}/$id",
      );

      if (response.statusCode == StatusCode.ok) {
        final data = jsonDecode(response.data);
        if (data != "null") {
          favourite.value = Favourite.fromJson(data);
          if (favourite.value?.isFav == true) {
            isFavString.value = favourite.value!.isFav.toString();
            isFav.value = true;
          } else {
            isFavString.value = favourite.value!.isFav.toString();
            isFav.value = false;
          }
        } else {
          isFavString.value = 'null';
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void searchDoctorsByType(String query) {
    if (query == '') {
      filteredDoctors.value = doctors;
    } else {
      filteredDoctors.value = doctors
          .where((vendor) =>
              vendor.type.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  Future<void> getVendors() async {
    isLoading.value = true;

    if (await networkInfo.isConnected) {
      final response = await dioConsumer.get(EndPoints.getVendor);

      print(response.data);
      if (response.statusCode == StatusCode.ok) {
        try {
          final List<dynamic> jsonData = json.decode(response.data);

          List<Vendor> vendors =
              jsonData.map((json) => Vendor.fromJson(json)).toList();
          searchDoctors('');
          doctors.value = vendors;
          for (var xx in doctors) {
            xx.fav == 0;
          }
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
        doctors.value = [];
        isLoading.value = false;
      }
    } else {
      Get.snackbar(
        "No Internet Connection",
        "Please check your network settings",
        snackPosition: SnackPosition.BOTTOM,
      );
      isLoading.value = false;
    }
  }

  Future<void> getVendorsById(id) async {
    if (await networkInfo.isConnected) {
      isLoadingVendor.value = true;

      final response = await dioConsumer.get(
        "${EndPoints.getVendorId}/$id/details",
      );

      if (response.statusCode == StatusCode.ok) {
        try {
          final dynamic jsonData = json.decode(response.data);

          doctor.value = DoctorModelById.fromJson(jsonData);
          imagesUrl.clear();
          imagesUrl.add(doctor.value!.businessImages.first.imgUrl1);
          imagesUrl.add(doctor.value!.businessImages.first.imgUrl2);
          imagesUrl.add(doctor.value!.businessImages.first.imgUrl3);

          await getFav(id);
          isLoadingVendor.value = false;
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
    } else {
      Get.snackbar(
        "No Internet Connection",
        "Please check your network settings",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> getVendorServices(
    id,
  ) async {
    services.clear();
    if (await networkInfo.isConnected) {
      final response = await dioConsumer.get(
        "${EndPoints.getVendorServices}/$id/all",
      );

      if (response.statusCode == StatusCode.ok) {
        try {
          final List<dynamic> jsonData = json.decode(response.data);

          List<Services> servicesData =
              jsonData.map((json) => Services.fromJson(json)).toList();

          services.value = servicesData;
          isLoadingVendor.value = false;
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
    } else {
      Get.snackbar(
        "No Internet Connection",
        "Please check your network settings",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> getPendingReview() async {
    if (await networkInfo.isConnected) {
      try {
        final response = await dioConsumer.get(
          "${EndPoints.getPendingReview}/${user.userId}",
        );
        if (response.statusCode == StatusCode.ok) {
          final List<dynamic> jsonData = json.decode(response.data);

          List<ReviewPending> pendingReview =
              jsonData.map((json) => ReviewPending.fromJson(json)).toList();
          reviewPinding.value = pendingReview;
          if (reviewPinding.isNotEmpty) {
            showReview.value = true;
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  Future<void> pickImages(context) async {
    final XFile? selectedImages =
        await _picker.pickImage(source: ImageSource.gallery);
    addingImage.value = true;

    await uploadImageToFirebase(File(selectedImages!.path), context);

    addingImage.value = false;

    // imageFiles.value = (File(selectedImages.take(3)).toList());
  }

  Future<String?> uploadImageToFirebase(File pickedFile, context) async {
    try {
      // Create a reference to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('reviewImage/${pickedFile.path.split('/').last}');

      await storageRef.putFile(pickedFile);

      // Get download URL
      String downloadURL = await storageRef.getDownloadURL();

      serviceImage.value = downloadURL;
      // await updateUserImage(downloadURL, context);
      addingImage.value = false;

      return downloadURL;
    } catch (e) {
      addingImage.value = false;

      return null;
    }
  }

  Future<void> postReview(reviewId, status) async {
    if (await networkInfo.isConnected) {
      try {
        var body = jsonEncode({
          "description": messageController.text.trim(),
          "imgUrl": serviceImage.value,
          "status": status,
          "reviewRate": userRating.value.toInt()
        });

        final response = await http.put(
            Uri.parse(
                'https://gts-b8dycqbsc6fqd6hg.uaenorth-01.azurewebsites.net/api/Review/$reviewId/user-update'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: body);

        if (response.statusCode == StatusCode.ok) {
          reviewPinding.clear();
          serviceImage.value = "";
          messageController.text = "";
          await getPendingReview();
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    }
  }

  Future<void> deleteReview(reviewId) async {
    if (await networkInfo.isConnected) {
      await dioConsumer.delete("${EndPoints.postReview}/$reviewId");

      Get.back();
      getPendingReview();
    }
  }
}

class Favourite {
  int favoriteId;
  bool isFav;
  Favourite({
    required this.favoriteId,
    required this.isFav,
  });
  factory Favourite.fromJson(Map<String, dynamic> json) {
    return Favourite(
      favoriteId: json['favoriteId'] ?? 0,
      isFav: json['isFav'] ?? false,
    );
  }
}
