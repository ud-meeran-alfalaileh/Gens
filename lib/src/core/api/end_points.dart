class EndPoints {
  static const String baseUrl = 'https://saad-ai.quickluxe.net/api/';
  static const String globalURL = 'https://saad-ai.quickluxe.net/api/v1/Client';

  //
  static const String mobileAPI = '${baseUrl}mobile/';
  static const String login = 'auth/login';
  static const String signup = 'auth/signup';
  static const String logout = 'auth/logout';
  static const String profile = 'auth/profile';
  static const String updateUser = 'auth/profile/update';
  static const String updateUserImage = 'auth/profile/change-photo';
  static const String conversation = '$globalURL/conversations';
  static const String addMessage = '$globalURL/messages';
  static const String addAiMessage = '$globalURL/messages/aiReplay';
  static const String getTopics = '$globalURL/topics';
  static const String getSlider = '$globalURL/sliders';
  static const String getCountry = '$globalURL/countries';
  static const String getSubscription = '$globalURL/subscriptions';
  static const String subscription = '$globalURL/subscriptions/';
  static const String apiKey =
      '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'; // Your OpenAI API key

  // static const String crateConversation = '$globalURL/conversations';
}
