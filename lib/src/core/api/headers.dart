// ignore: constant_identifier_names

const String baseURL = "https://api.openai.com/v1";

String endPoint(String endPoint) => "$baseURL/$endPoint";

Map<String, String> headerBearerOption(String token) => {
      "Content-Type": "application/json",
      'Accept': 'application/json',
    };

enum ApiState { loading, success, error, notFound }
