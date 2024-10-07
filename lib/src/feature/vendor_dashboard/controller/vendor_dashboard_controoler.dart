import 'dart:convert';

import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:gens/src/core/api/api_services.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/injection_container.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/history/model/history_model.dart';
import 'package:gens/src/feature/waiting_list/model/waiting_list_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

class VendorDashboardController extends GetxController {
  RxBool isLaoding = false.obs;
  RxList<VendorBooking> vendorBooking = <VendorBooking>[].obs;
  RxList<VendorBooking> allVendorBooking = <VendorBooking>[].obs;
  RxList<VendorBooking> todayVendorBooking = <VendorBooking>[].obs;
  RxList<VendorBooking> filteredBooking = <VendorBooking>[].obs;
  final DioConsumer dioConsumer = sl<DioConsumer>();
  RxList<WaitingListModel> waitingList = <WaitingListModel>[].obs;
  User user = User();
  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());
  RxBool statusUpadating = false.obs;
  RxBool todaycontainer = false.obs;

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

  @override
  Future<void> onInit() async {
    await user.loadToken();
    await getWaitingList();
    super.onInit();
  }

  void filterBooking(String query) {
    if (query == '') {
      isFilterd.value = false;
      todaycontainer.value = false;
    } else if (query == 'Today') {
      isFilterd.value = true;

      filteredBooking.value = todayVendorBooking;
      todaycontainer.value = true;
    } else {
      isFilterd.value = true;
      todaycontainer.value = false;

      filteredBooking.value = allVendorBooking
          .where((vendor) => vendor.status.contains(query))
          .toList();
      for (var xx in allVendorBooking) {
        print(xx.endTime);
        print("xx.endTime");
      }
      print(allVendorBooking.length);
      print(filteredBooking.length);
      print(query);
    }
  }

  Future<void> makePhoneCall(String phoneNumber) async {
    var number = phoneNumber; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  Future<void> getVendorBoooking(context) async {
    vendorBooking.clear();
    todayVendorBooking.clear();
    if (await networkInfo.isConnected) {
      isLaoding.value = true;
      try {
        final response = await dioConsumer
            .get("${EndPoints.getBookingVendor}${user.vendorId.value}/details");
        if (response.statusCode == StatusCode.ok) {
          final List<dynamic> jsonData = json.decode(response.data);

          List<VendorBooking> servicesData =
              jsonData.map((json) => VendorBooking.fromJson(json)).toList();

          allVendorBooking.value = servicesData;
          for (var xx in allVendorBooking) {
            if (xx.date == getFormattedTodayDate()) {
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

  Future<void> updateBookingStatus(
      String status,
      int serviceId,
      VendorBooking booking,
      RxBool statusUpadating,
      bool removeFromSchulde) async {
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
          );

          // Update the booking list in the controller
          updateBookingInList(updatedBooking);
          statusUpadating.value = false;
        }
      } catch (e) {
        statusUpadating.value = false;
      }
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
      print(response.statusCode);
      print(response.data);
      if (response.statusCode == StatusCode.ok) {
        final List<dynamic> jsonData = json.decode(response.data);

        List<WaitingListModel> waitingData =
            jsonData.map((json) => WaitingListModel.fromJson(json)).toList();
        waitingList.value = waitingData;
        print("Waining time${waitingList.length}");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateWaitingStatus(
    String status,
    int listItemId,
    WaitingListModel booking,
    RxBool statusUpadating,
  ) async {
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
        print(response.statusCode);
        print(response.body);
        if (response.statusCode == StatusCode.ok) {
          // Create a new instance with updated status
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
        print(e);
        statusUpadating.value = false;
      }
    }
  }
}
