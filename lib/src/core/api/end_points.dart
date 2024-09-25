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
  static const String logout = '${baseUrl}User/logout';
  static const String profile = 'auth/profile';
  static const String postSchadule = '${baseUrl}Schedule/create';
  static const String updateSchadule = '${baseUrl}Schedule/UpdateWorkingDay';
  static const String getSchadule =
      '${baseUrl}Schedule/GetWorkingDaysAndTimes/';
  static const String postBooking = '${baseUrl}Booking';
  static const String vendorHistory = '${baseUrl}Booking/vendor';
  static const String getBooking = '${baseUrl}Booking/user/';
  static const String getBookingVendor = '${baseUrl}Booking/vendor/';
  static const String getvendorServices = '${baseUrl}Service/vendor';
  static const String ediSvendorServices = '${baseUrl}Service';
  static const String getPendingReview = '${baseUrl}Review/pending/user';
  static const String postReview = '${baseUrl}Review';
  static const String postFav = '${baseUrl}Favorite';
  static const String getFav = '${baseUrl}Favorite/check-favorite-status/';
  static const String getQuestion = '${baseUrl}Questionnaire';

  static const String getAllFav = '${baseUrl}Favorite/user/Favorites/';
  static const String addImage = '${baseUrl}UserImages/create';

  static const String skinGoals =
      '${baseUrl}Questionnaire/PostMainSkincareGoalsByUserId/';
  static const String firstPage = '${baseUrl}Questionnaire/post-skin-section';
  static const String secPage =
      '${baseUrl}Questionnaire/post-hormonal-gi-section';
  static const String thirdPage =
      'https://gts-b8dycqbsc6fqd6hg.uaenorth-01.azurewebsites.net/post-hormone-related-section';
  static const String fourthPage =
      '${baseUrl}Questionnaire/post-skincare-goals-section';
  static const String timeslotsForDay =
      '${baseUrl}Schedule/generate-timeslotsForDay/TestAndTest';

  static String resetPassword =
      "https://gts-b8dycqbsc6fqd6hg.uaenorth-01.azurewebsites.net/reset-password";

  // static const String crateConversation = '$globalURL/conversations';
}
