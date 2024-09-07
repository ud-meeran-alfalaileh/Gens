import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final RxString userId = "".obs;
  final RxString otpCode = ''.obs;

  clearId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('LoginId');
    userId.value = "";
  }

  loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getString('LoginId') ?? "";
    print("Loaded Token : $userId");
  }

  saveId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('LoginId', id); // Save the passed id
  }

  clearOtp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('OtpCode');
    otpCode.value = "";
  }

  loadOtp() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    otpCode.value = prefs.getString('OtpCode') ?? "";
    print("Loaded Token : $otpCode");
  }

  saveOtp(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('OtpCode', id); // Save the passed id
  }
}
