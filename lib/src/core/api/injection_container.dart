import 'package:gens/src/feature/vendor_calendar/controller/vendor_calendar_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:gens/src/core/api/api_services.dart';
import 'package:gens/src/core/api/app_interceptors.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Register Dio
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.interceptors.add(sl<AppIntercepters>());
    return dio;
  });


  // Register AppIntercepters
  sl.registerLazySingleton<AppIntercepters>(() => AppIntercepters());

  // Register DioConsumer
  sl.registerLazySingleton<DioConsumer>(() => DioConsumer(client: sl<Dio>()));

  // Register PostsController

  // Register SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // Register LogInterceptor
  sl.registerLazySingleton<LogInterceptor>(() => LogInterceptor());
}
