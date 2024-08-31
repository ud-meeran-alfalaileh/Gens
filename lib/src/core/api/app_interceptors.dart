import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:gens/src/core/user.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:gens/src/core/api/injection_container.dart' as di;

class AppIntercepters extends Interceptor {
  User user = User();
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    const loginUath = "/auth/login";
    const registerUath = "/auth/register";
    const localCountry = "/auth/register";
    if (!options.path.contains(loginUath) &&
        !options.path.contains(registerUath) &&
        !options.path.contains(localCountry) &&
        di.sl<SharedPreferences>().getString("token") != '') {
      await user.loadToken();
      options.headers['Authorization'] = 'Bearer ${user.token}';
    }
    options.headers['Accept'] = 'application/json';
    log("TOKEN: ${options.headers['Authorization']}");
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    super.onError(err, handler);
  }
}
