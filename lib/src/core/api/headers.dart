// ignore: constant_identifier_names
const String OPEN_AI_KEY =
    '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'; // Your OpenAI API key

const String baseURL = "https://api.openai.com/v1";

String endPoint(String endPoint) => "$baseURL/$endPoint";

Map<String, String> headerBearerOption(String token) => {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };

enum ApiState { loading, success, error, notFound }
