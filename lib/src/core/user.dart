import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final RxString userId = "".obs;
  final RxString googleToken = ''.obs;
  final RxString userName = "".obs;
  final RxString profileImage = "".obs;
  final RxBool subscripeId = false.obs;

  clearId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('LoginId');
    userId.value = "";
  }

  loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId.value = prefs.getString('LoginId') ?? "";
    print("Loaded Token : ${userId}");
  }

  saveId(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('LoginId', id); // Save the passed id
  }
}
