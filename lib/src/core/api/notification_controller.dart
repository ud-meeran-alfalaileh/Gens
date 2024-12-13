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
        "route": model.route,
        "externalIds": [model.externalIds.toString()]
      };

      final response =
          await dioConsumer.post(EndPoints.sendNotification, body: body);
      print(response.data);
      print(response.statuscode);
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
  String route;
  NotificationModel({
    required this.title,
    required this.message,
    required this.route,
    required this.imageURL,
    required this.externalIds,
  });
}
