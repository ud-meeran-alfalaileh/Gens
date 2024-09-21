import 'dart:convert';

import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/user.dart';
import 'package:gens/src/feature/history/model/history_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class VendorDashboardController extends GetxController {
  RxBool isLaoding = false.obs;
  RxList<VendorBooking> vendorBooking = <VendorBooking>[].obs;
  RxList<VendorBooking> allVendorBooking = <VendorBooking>[].obs;
  RxList<VendorBooking> todayVendorBooking = <VendorBooking>[].obs;
  RxList<VendorBooking> filteredBooking = <VendorBooking>[].obs;

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
  void onInit() {
    user.loadToken();
    user.vendorId();
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
    final Uri callUri = Uri(scheme: 'tel', path: '+962791368191');
    try {
      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri);
      } else {
        throw 'Could not launch $phoneNumber';
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getVendorBoooking(context) async {
    vendorBooking.clear();
    todayVendorBooking.clear();
    if (await networkInfo.isConnected) {
      isLaoding.value = true;
      try {
        final response = await http.get(
          Uri.parse(
              "https://gts-b8dycqbsc6fqd6hg.uaenorth-01.azurewebsites.net/api/Booking/vendor/${user.vendorId.value}/details"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );
        print(response.body);
        print(response.statusCode);
        if (response.statusCode == StatusCode.ok) {
          final List<dynamic> jsonData = json.decode(response.body);

          List<VendorBooking> servicesData =
              jsonData.map((json) => VendorBooking.fromJson(json)).toList();

          allVendorBooking.value = servicesData;
          print(allVendorBooking.length);
          for (var xx in allVendorBooking) {
            print(xx.status);
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

  Future<void> updateBookingStatus(String status, int serviceId,
      VendorBooking booking, RxBool statusUpadating) async {
    if (await networkInfo.isConnected) {
      try {
        statusUpadating.value = true;
        var body = jsonEncode(status);
        await Future.delayed(const Duration(milliseconds: 600));
        final response = await http.post(
          Uri.parse("${EndPoints.postBooking}/$serviceId/status"),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: body,
        );
        print(response.body);
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
        print(e);
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
}
