import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final RxInt userId = 0.obs;
  final RxInt vendorId = 0.obs;
  final RxString otpCode = ''.obs;

  clearId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('LoginId');
    userId.value = 0;
  }

  loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getInt('LoginId') ?? 0;
    vendorId.value = prefs.getInt('VendorId') ?? 0;
  }

  saveId(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('LoginId', id); // Save the passed id
  }

  clearVendorId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('VendorId');
    userId.value = 0;
  }

  loadVendorId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    vendorId.value = prefs.getInt('VendorId') ?? 0;
  }

  saveVendorId(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('VendorId', id); // Save the passed id
  }

  clearOtp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('OtpCode');
    otpCode.value = "";
  }

  loadOtp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    otpCode.value = prefs.getString('OtpCode') ?? "";
  }

  saveOtp(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('OtpCode', id); // Save the passed id
  }
}
