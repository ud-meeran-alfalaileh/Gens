import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:gens/src/core/api/api_services.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/injection_container.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/api/notification_controller.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/history/model/history_model.dart';
import 'package:gens/src/feature/waiting_list/model/waiting_list_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

class VendorDashboardController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPageIndex = 0.obs;
  final noteMessage = TextEditingController();

  RxBool isLaoding = false.obs;
  RxBool noteSended = false.obs;
  RxList<VendorBooking> vendorBooking = <VendorBooking>[].obs;
  RxList<VendorBooking> allVendorBooking = <VendorBooking>[].obs;
  RxList<VendorBooking> todayVendorBooking = <VendorBooking>[].obs;
  final DioConsumer dioConsumer = sl<DioConsumer>();
  RxList<WaitingListModel> waitingList = <WaitingListModel>[].obs;
  User user = User();
  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());
  RxBool statusUpadating = false.obs;
  RxBool todaycontainer = false.obs;
  final notificationController = Get.put(NotificationController());
  String getFormattedTodayDate() {
    DateTime today = DateTime.now();
    DateFormat formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(today);
    return formattedDate;
  }

  RxBool isFilterd = false.obs;
  RxInt selectedIndex = 0.obs;
  RxString searchValue = ''.obs;

  void setSelectedIndex(int index) {
    selectedIndex.value = index;
  }

// Inside your controller
  void setPageIndex(int index) {
    currentPageIndex.value = index;
    currentPageIndex.value = index;
  }

  @override
  Future<void> onInit() async {
    await user.loadToken();
    await getWaitingList();
    // getVendorBoooking();
    super.onInit();
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    var number = phoneNumber; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  Future<void> getVendorBoooking() async {
    isLaoding.value = true;

    vendorBooking.clear();
    allVendorBooking.clear();
    todayVendorBooking.clear();
    if (await networkInfo.isConnected) {
      try {
        final response = await dioConsumer
            .get("${EndPoints.getBookingVendor}${user.vendorId.value}/details");
        print(response.data);
        if (response.statusCode == StatusCode.ok) {
          final List<dynamic> jsonData = json.decode(response.data);

          List<VendorBooking> servicesData =
              jsonData.map((json) => VendorBooking.fromJson(json)).toList();

          allVendorBooking.value = servicesData;
          print(allVendorBooking.length);
          for (var xx in allVendorBooking) {
            if (xx.date == getFormattedTodayDate()) {
              print(xx.id);

              todayVendorBooking.add(xx);
            } else {
              vendorBooking.add(xx);
            }
          }
          isLaoding.value = false;
        } else {
          vendorBooking.value = [];
          isLaoding.value = false;
        }
      } catch (e) {
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

  Future<void> getVendorBoookingToday() async {
    allVendorBooking.clear();
    todayVendorBooking.clear();
    if (await networkInfo.isConnected) {
      isLaoding.value = true;
      try {
        final response = await dioConsumer
            .get("${EndPoints.getBookingToday}${user.vendorId.value}");
        print(response.data);
        if (response.statusCode == StatusCode.ok) {
          final List<dynamic> jsonData = json.decode(response.data);
// todaycontainer.value = true
          todayVendorBooking.value =
              jsonData.map((json) => VendorBooking.fromJson(json)).toList();
          print('todayVendorBooking.length');
          print(todayVendorBooking.length);
          isLaoding.value = false;
        } else {
          vendorBooking.value = [];
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

  Future<void> getVendorBoookingFilterd(status) async {
    allVendorBooking.clear();
    todayVendorBooking.clear();
    if (await networkInfo.isConnected) {
      isLaoding.value = true;
      try {
        final response = await dioConsumer.get(
            "${EndPoints.getBookingVendor}${user.vendorId.value}/$status/details");
        print(response.data);
        if (response.statusCode == StatusCode.ok) {
          final List<dynamic> jsonData = json.decode(response.data);

          List<VendorBooking> servicesData =
              jsonData.map((json) => VendorBooking.fromJson(json)).toList();

          allVendorBooking.value = servicesData;
          print(allVendorBooking.length);

          isLaoding.value = false;
        } else {
          vendorBooking.value = [];
          isLaoding.value = false;
        }
      } catch (e) {
        print("Errror");
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

  Future<void> updateBookingStatus(
      String status,
      int serviceId,
      VendorBooking booking,
      RxBool statusUpadating,
      bool removeFromSchulde,
      externalId) async {
    if (await networkInfo.isConnected) {
      try {
        statusUpadating.value = true;
        var body = jsonEncode(
            {'removeFromSchulde': removeFromSchulde, 'newStatus': status});
        await Future.delayed(const Duration(milliseconds: 600));
        final response = await dioConsumer.post(
          "${EndPoints.postBooking}/$serviceId/status",
          body: body,
        );
        if (response.statusCode == StatusCode.ok) {
          await senNotification(status, externalId);
          // Create a new instance with updated status
          final updatedBooking = VendorBooking(
              status: status.replaceAll('"', status),
              userName: booking.userName,
              userImage: booking.userImage,
              userPhoneNumber: booking.userPhoneNumber,
              serviceTitle: booking.serviceTitle,
              date: booking.date,
              startTime: booking.startTime,
              endTime: booking.endTime,
              id: booking.id,
              userId: booking.userId,
              showNote: status == "Done" ? true : false);

          // Update the booking list in the controller
          updateBookingInList(updatedBooking);
          statusUpadating.value = false;
        }
      } catch (e) {
        print("Notofication $e");
        statusUpadating.value = false;
      }
    }
  }

  Future<void> senNotification(status, externalId) async {
    if (status == "Done") {
      notificationController.sendNotification(NotificationModel(
          title: "Appointment Completed",
          message:
              "Your appointment has been successfully completed. We hope the service met your expectations. Thank you!",
          imageURL: "",
          externalIds: externalId,
          route: 'NavBarPage'));
    }
    if (status == "Upcoming") {
      notificationController.sendNotification(NotificationModel(
          title: "Appointment Approved",
          message: "Your appointment has been successfully approved.",
          imageURL: '',
          externalIds: externalId,
          route: 'NavBarPage'));
    }
    if (status == "Absent") {
      notificationController.sendNotification(NotificationModel(
          title: "Appointment Marked as Absent",
          message: "You were marked as absent for your scheduled appointment.",
          imageURL: '',
          externalIds: externalId,
          route: 'NavBarPage'));
    }
    if (status == "Rejected") {
      notificationController.sendNotification(NotificationModel(
          title: 'Rejected Appointment',
          message:
              "Unfortunately, your appointment request has been rejected. ",
          imageURL: '',
          externalIds: externalId,
          route: 'NavBarPage'));
    }
  }

  void updateBookingInList(VendorBooking updatedBooking) {
    int index =
        vendorBooking.indexWhere((booking) => booking.id == updatedBooking.id);
    if (index != -1) {
      vendorBooking[index] = updatedBooking;
      vendorBooking.refresh(); // Refresh the list to update the UI
    }
    int todayIndex = todayVendorBooking
        .indexWhere((booking) => booking.id == updatedBooking.id);
    if (todayIndex != -1) {
      todayVendorBooking[todayIndex] = updatedBooking;
      todayVendorBooking.refresh(); // Refresh the list to update the UI
    }

    // Update all bookings list
    int allIndex = allVendorBooking
        .indexWhere((booking) => booking.id == updatedBooking.id);
    if (allIndex != -1) {
      allVendorBooking[allIndex] = updatedBooking;
      allVendorBooking.refresh(); // Refresh the list to update the UI
    }
  }

  void updateWaitingInList(WaitingListModel updatedWaiting) {
    int index =
        waitingList.indexWhere((booking) => booking.id == updatedWaiting.id);
    if (index != -1) {
      waitingList[index] = updatedWaiting;
      waitingList.refresh(); // Refresh the list to update the UI
    }

    // Update all bookings list
  }

  Future<void> getWaitingList() async {
    try {
      final response = await dioConsumer
          .get("${EndPoints.addWaitingList}/vendor/${user.vendorId}");

      if (response.statusCode == StatusCode.ok) {
        final List<dynamic> jsonData = json.decode(response.data);

        List<WaitingListModel> waitingData =
            jsonData.map((json) => WaitingListModel.fromJson(json)).toList();
        waitingList.value = waitingData;
      } else {
        waitingList.value = [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> updateWaitingStatus(
      String status,
      int listItemId,
      WaitingListModel booking,
      RxBool statusUpadating,
      String userPhone) async {
    if (await networkInfo.isConnected) {
      try {
        statusUpadating.value = true;
        var body = jsonEncode(status);
        await Future.delayed(const Duration(milliseconds: 600));
        final response = await http.put(
          Uri.parse("${EndPoints.addWaitingList}/$listItemId/status"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: body,
        );

        if (response.statusCode == StatusCode.ok) {
          if (status == "Accept") {
            notificationController.sendNotification(NotificationModel(
                title: "Waiting List Request Accepted",
                message:
                    "Good news! Your request from the waiting list has been accepted. You are now scheduled for an appointment. Please check the details and confirm your availability.",
                imageURL: "",
                externalIds: userPhone,
                route: 'waiting'));
          }
          if (status == "Reject") {
            notificationController.sendNotification(NotificationModel(
                title: 'Waiting List Request Rejected',
                message:
                    "Unfortunately, your request from the waiting list could not be accommodated at this time. Please try again or contact us for further assistance.",
                imageURL: "",
                externalIds: userPhone,
                route: 'waiting'));
          }
          final updatedBooking = WaitingListModel(
            status: status.replaceAll('"', status),
            userName: booking.userName,
            userPhoneNumber: booking.userPhoneNumber,
            startTime: booking.startTime,
            endTime: booking.endTime,
            id: booking.id,
            userId: booking.userId,
            serviceId: booking.serviceId,
            startDate: booking.startDate,
            endDate: booking.endDate,
            message: booking.message,
          );

          // Update the booking list in the controller
          updateWaitingInList(updatedBooking);
          statusUpadating.value = false;
        }
      } catch (e) {
        statusUpadating.value = false;
      }
    }
  }

  Future<void> addNote(VendorBooking booking, String note) async {
    try {
      // Create the request body as a plain string, encoded properly
      var body = jsonEncode(
        note,
      );

      await http.put(
        Uri.parse(
            'https://gts-b8dycqbsc6fqd6hg.uaenorth-01.azurewebsites.net/api/Booking/update-note/${booking.id}'),
        body: body,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      noteSended.value = true;

      final updatedBooking = VendorBooking(
          status: "Done",
          userName: booking.userName,
          userImage: booking.userImage,
          userPhoneNumber: booking.userPhoneNumber,
          serviceTitle: booking.serviceTitle,
          date: booking.date,
          startTime: booking.startTime,
          endTime: booking.endTime,
          id: booking.id,
          userId: booking.userId,
          showNote: false,
          note: note);

      // Update the booking list in the controller
      updateBookingInList(updatedBooking);
      statusUpadating.value = false;
      noteMessage.clear();
      // ignore: empty_catches
    } catch (e) {}
  }
}
