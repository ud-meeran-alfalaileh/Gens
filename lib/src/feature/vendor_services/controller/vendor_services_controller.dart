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
import 'package:gens/src/core/utils/snack_bar.dart';
import 'package:gens/src/feature/doctor_profile/model/service_model.dart';
import 'package:gens/src/feature/vendor_navbar.dart/view/widget/main_widget/vendor_navbar_page.dart';
import 'package:gens/src/feature/vendor_services/model/pre_service_model.dart';
import 'package:gens/src/feature/vendor_services/view/widget/main_widget/add_service_widget.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class VendorServicesController extends GetxController {
  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());
  RxList<Services> services = <Services>[].obs;
  final DioConsumer dioConsumer = sl<DioConsumer>();
  var instructionId = 0.obs;
  var isLoading = false.obs;
  User user = User();
  RxList<Prescription> prescription = <Prescription>[].obs;
  final ImagePicker _picker = ImagePicker();
  RxInt serviceId = 0.obs;
  final title = TextEditingController();
  final description = TextEditingController();
  final preDescription = TextEditingController();

  final price = TextEditingController();
  final imageUrl = TextEditingController();
  final postInstructionDays = TextEditingController();
  var daysOfInstruction = 0.obs;
  RxString serviceImage = "".obs;
  RxBool isUpdating = false.obs;
  Future<void> pickImages(BuildContext context) async {
    final XFile? selectedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (selectedImage == null) {
      return;
    } else {
      await uploadImageToFirebase(File(selectedImage.path), context);
    }
  }

  bool areAllInstructionsFilled() {
    for (var controller in instructionControllers) {
      if (controller.text.trim().isEmpty) {
        return false; // Return false if any controller's text is empty
      }
    }
    return true; // All controllers have non-empty text
  }

  List<TextEditingController> instructionControllers = [];

  void updateInstructionControllers(int days) {
    while (instructionControllers.length < days) {
      instructionControllers.add(TextEditingController());
    }
    while (instructionControllers.length > days) {
      instructionControllers.removeLast();
    }
  }

  @override
  void onClose() {
    // Dispose controllers when not needed
    for (var controller in instructionControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  Future<String?> uploadImageToFirebase(File pickedFile, context) async {
    try {
      isUpdating.value = true;

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
        final response = await dioConsumer.get(
          '${EndPoints.getVendorServices}/${user.vendorId}/all',
        );
        if (response.statusCode == StatusCode.ok) {
          try {
            final jsonData = json.decode(response.data);

            // Cast jsonData to List to use map properly
            List<Services> servicesData = (jsonData as List)
                .map((item) => Services.fromJson(item))
                .toList();

            services.value = servicesData;
          } catch (e) {
            services.value = [];
          }
        } else {
          services.value = [];
        }
      } catch (e) {
        services.value = [];
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
        final response = await dioConsumer
            .delete('${EndPoints.ediSvendorServices}/$serviceId');

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

  Future<void> addService(context) async {
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
            await dioConsumer.post(EndPoints.ediSvendorServices, body: body);
        if (response.statusCode == StatusCode.created) {
          try {
            serviceId.value = jsonDecode(response.data)['serviceId'];
            print(serviceId.value);
            showSnackBar("Success", "Service Add Successfully ", Colors.green);
            await Future.delayed(const Duration(seconds: 1));
            addServiceServyPopUp(context);
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

  Future<void> addInstruction() async {
    isLoading.value = true;
    if (await networkInfo.isConnected) {
      isUpdating.value = true;
      try {
        var body = jsonEncode({
          "id": 0,
          "serviceId": serviceId.value,
          "title": "string",
          "period": int.parse(postInstructionDays.text),
        });
        print(body);
        final response =
            await dioConsumer.post(EndPoints.postInstruction, body: body);
        print(response.data);
        print(response.statusCode);
        if (response.statusCode == StatusCode.ok) {
          final responseData = json.decode(response.data)['id'];
          instructionId.value = responseData;
          await addInstructionDay();
          isLoading.value = false;

          Get.offAll(const VendorNavBar());
          postInstructionDays.clear();
        } else {
          isLoading.value = false;

          Get.snackbar(
            "Error",
            "Failed to add instruction",
            snackPosition: SnackPosition.BOTTOM,
          );
          isUpdating.value = false;
        }
      } catch (e) {
        isLoading.value = false;

        isUpdating.value = false;
      }
    }
  }

  Future<void> addInstructionDay() async {
    for (int i = 0; i < instructionControllers.length; i++) {
      try {
        var body = {
          "id": 0,
          "medicalPrescriptionId": instructionId.value,
          "day": i + 1, // Use the index + 1
          "description":
              instructionControllers[i].text // Use the controller's text
        };
        final response =
            await dioConsumer.post(EndPoints.medicalPlan, body: body);
        print(response.data);
        print(response.data);

        if (response.statusCode == StatusCode.created) {
          postInstructionDays.text = '0';
          daysOfInstruction.value = 0;
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> getPreInstruction(id) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await dioConsumer.get("${EndPoints.medicalPlan}/service/$id");
        print(response.data);

        if (response.statusCode == StatusCode.ok) {
          // Decode JSON to List<dynamic> to be properly typed
          final List<dynamic> responseData = jsonDecode(response.data);

          // Map the List<dynamic> to List<Prescription>
          final List<Prescription> prescriptions =
              responseData.map((json) => Prescription.fromJson(json)).toList();
          prescription.value = prescriptions;
          print(prescriptions.length);
        }
      } catch (e) {
        print(e);
      }
    }
  }

  void updateBookingInList(Prescription updatedBooking) {
    int index =
        prescription.indexWhere((booking) => booking.id == updatedBooking.id);
    if (index != -1) {
      prescription[index] = updatedBooking;
      prescription.refresh(); // Refresh the list to update the UI
    }
  }

  Future<void> editPreInstruction(Prescription model) async {
    if (await networkInfo.isConnected) {
      try {
        var body = jsonEncode({
          "id": model.id,
          "medicalPrescriptionId": model.medicalPrescriptionId,
          "day": model.id,
          "description": preDescription.text.trim()
        });
        final response = await http.put(Uri.parse(EndPoints.medicalPlan),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: body);
        if (response.statusCode == StatusCode.ok) {
          final updatedPre = Prescription(
              id: model.id,
              medicalPrescriptionId: model.medicalPrescriptionId,
              day: model.id,
              description: preDescription.text.trim());

          // Update the booking list in the controller
          updateBookingInList(updatedPre);

          Get.back();
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
