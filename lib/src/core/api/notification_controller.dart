import 'package:gens/src/core/api/api_services.dart';
import 'package:gens/src/core/api/end_points.dart';
import 'package:gens/src/core/api/injection_container.dart';
import 'package:gens/src/core/api/netwok_info.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NotificationController extends GetxController {
  final NetworkInfo networkInfo =
      NetworkInfoImpl(connectionChecker: InternetConnectionChecker());
  final DioConsumer dioConsumer = sl<DioConsumer>();

  Future<void> sendNotification(NotificationModel model) async {
    try {
      var body = {
        "title": model.title,
        "message": model.message,
        "imageUrl": model.imageURL,
        "externalIds": [model.externalIds.toString()]
      };
      print(body);
      final response =
          await dioConsumer.post(EndPoints.sendNotification, body: body);
      print(response.data);
      print(response.statusCode);
    } catch (e) {
      print(e);
    }
  }
}

class NotificationModel {
  String title;
  String message;
  String imageURL;
  String externalIds;
  NotificationModel({
    required this.title,
    required this.message,
    required this.imageURL,
    required this.externalIds,
  });
}