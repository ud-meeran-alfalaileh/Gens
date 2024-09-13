import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingController extends GetxController {
  var isArabic = true.obs;
  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  void setLanguage(String value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value == "ar") {
      isArabic.value = true;
      await prefs.setBool('isArabic', true);
    } else {
      isArabic.value = false;
      await prefs.setBool('isArabic', false);
    }
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    isArabic.value = prefs.getBool('isArabic') ?? true;
  }
}
