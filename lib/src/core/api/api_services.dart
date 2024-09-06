import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:gens/src/core/api/app_interceptors.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/injection_container.dart' as di;
import 'package:gens/src/core/api/status_code.dart';
import 'package:gens/src/core/error/exceptions.dart';
import 'package:gens/src/core/user.dart';

import 'api_consumer.dart';

class DioConsumer implements ApiConsumer {
  final Dio client;
  User user = User();
  DioConsumer({required this.client}) {
    // ignore: deprecated_member_use
    (client.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    _setHeaders();

    client.interceptors.add(di.sl<AppIntercepters>());
    client.interceptors.add(di.sl<LogInterceptor>());
  }

  void _setHeaders() async {
    // final prefs = await SharedPreferences.getInstance();

    client.options
      ..baseUrl = EndPoints.baseUrl
      ..responseType = ResponseType.plain
      ..followRedirects = false
      ..receiveDataWhenStatusError = true
      ..headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      }
      ..validateStatus = (status) {
        return status! < StatusCode.internalServerError;
      };
  }

  @override
  Future get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await client.get(path, queryParameters: queryParameters);
      return response;
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future post(String path,
      {dynamic body,
      bool formDataIsEnabled = false,
      Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await client.post(path,
          queryParameters: queryParameters,
          data: formDataIsEnabled ? FormData.fromMap(body!) : body);
      return response;
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  // Other methods remain unchanged...

  dynamic _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw const FetchDataException();
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case StatusCode.badRequest:
            throw const BadRequestException();
          case StatusCode.unauthorized:
          case StatusCode.forbidden:
            throw const UnauthorizedException();
          case StatusCode.notFound:
            throw const NotFoundException();
          case StatusCode.conflict:
            throw const ConflictException();
          case StatusCode.internalServerError:
            throw const InternalServerErrorException();
        }
        break;
      case DioExceptionType.cancel:
        break;
      case DioExceptionType.unknown:
      case DioExceptionType.badCertificate:
      case DioExceptionType.connectionError:
        throw const NoInternetConnectionException();
    }
  }

  @override
  Future put(String path,
      {Map<String, dynamic>? body,
      Map<String, dynamic>? queryParameters}) async {
    final response =
        await client.put(path, queryParameters: queryParameters, data: body);
    return response;
  }

  @override
  Future delete(String path,
      {dynamic body,
      bool formDataIsEnabled = false,
      Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await client.delete(path,
          queryParameters: queryParameters,
          data: formDataIsEnabled ? FormData.fromMap(body!) : body);
      return response;
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }
}
