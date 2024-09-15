class EndPoints {
  static const String baseUrl =
      'https://gts-b8dycqbsc6fqd6hg.uaenorth-01.azurewebsites.net/api/';
  static const String globalURL = 'https:/api/v1/Client';

  //
  static const String mobileAPI = '${baseUrl}mobile/';
  static const String login = '${baseUrl}User/loginForUsers';
  static const String vendorLogin = '${baseUrl}Vendor/login';
  static const String signup = '${baseUrl}User/register';
  static const String vendorRignup = '${baseUrl}Vendor';
  static const String getVendor = '${baseUrl}Vendor/dashboard';
  static const String getVendorId = '${baseUrl}Vendor';
  static const String getVendorServices = '${baseUrl}Service/vendor';
  static const String senMessage = '${baseUrl}User/sendemail';
  static const String getUser = '${baseUrl}User';
  static const String updateImage = '${baseUrl}User/changeimage';
  static const String logout = 'auth/logout';
  static const String profile = 'auth/profile';
  static const String postSchadule = '${baseUrl}Schedule/create';
  static const String postBooking = '${baseUrl}Booking';
  static const String getBooking = '${baseUrl}Booking/user/';
  static const String getBookingVendor = '${baseUrl}Booking/vendor/';
  static const String getvendorServices = '${baseUrl}Service/vendor';
  static const String ediSvendorServices = '${baseUrl}Service';
  static const String getPendingReview = '${baseUrl}Review/pending/user';
  static const String postReview = '${baseUrl}Review';
  static const String postFav = '${baseUrl}Favorite';
  static const String timeslotsForDay =
      '${baseUrl}Schedule/generate-timeslotsForDay';

  // static const String crateConversation = '$globalURL/conversations';
}
