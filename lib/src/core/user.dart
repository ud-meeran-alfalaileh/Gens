 

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final RxString token = ''.obs;
  final RxString googleToken = ''.obs;
  final RxString userName = "".obs;
  final RxString profileImage = "".obs;
  final RxBool subscripeId = false.obs;

  Future<void> loadUserDetailsFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    userName.value = prefs.getString('username') ?? '';
    profileImage.value = prefs.getString('PictureThumb') ?? ''; 
  }

  Future<void> saveUserDetailsToPreferences(profileImage, userName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', userName);
    await prefs.setString('PictureThumb', profileImage);
  }

  clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('LoginToken');
    token.value = '';
  }

  loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token.value = prefs.getString('LoginToken') ?? '';
    // print("Loaded Token : ${token}");
  }

  saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('LoginToken', token);
  }

  clearGoogleToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('Google_token');
    googleToken.value = '';
  }

  loadGoogleToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    googleToken.value = prefs.getString('Google_token') ?? '';
  }

  saveGoogleToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Google_token', token);
    
     
  }


  // Future<bool> loadSubscriptionId() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final savedSubscriptionId = prefs.getBool('subscriptionId');
  //   if (savedSubscriptionId != null) {
  //     subscripeId.value = savedSubscriptionId;
  //     return subscripeId.value;
  //   }
  //   return savedSubscriptionId!;
  // }

  // void saveSubscriptionId(bool subscriptionId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('subscriptionId', subscriptionId);

  //   print("{{{{{{{{{{{{{{{{{subscriptionId}}}}}}}}}}}}}}}}}");
  //   print(subscriptionId);
  //   print("{{{{{{{{{{{{{{{{{subscriptionId}}}}}}}}}}}}}}}}}");
  // }


}
