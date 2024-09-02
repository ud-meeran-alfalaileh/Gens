import 'package:gens/src/feature/doctor_profile/model/doctor_model.dart';
import 'package:get/get.dart';

class DoctorController extends GetxController {
  var isExpanded = false.obs;

  void toggleExpanded() {
    isExpanded.value = !isExpanded.value;
  }

  RxList<DoctorModel> doctors = [
    DoctorModel(
        name: "Israa Elshebli",
        type: "Cardiologist",
        location: "Arab Bank, Pr.8, Amman",
        img: "assets/image/doctor.avif",
        about:
            "Israa Elshebli, a dedicated cardiologist, brings a wealth of experience to Golden Gate Cardiology Center in Golden Gate, CA.",
        patient: 2000,
        rating: 4.7,
        review: 1222,
        workingTime: "Monday-Friday, 08.00 AM-18.00 pM"),
    DoctorModel(
        name: "Israa Elshebli",
        type: "Cardiologist",
        location: "Arab Bank, Pr.8, Amman",
        img: "assets/image/doctor.avif",
        about:
            "Israa Elshebli, a dedicated cardiologist, brings a wealth of experience to Golden Gate Cardiology Center in Golden Gate, CA.",
        patient: 2000,
        rating: 4.7,
        review: 1222,
        workingTime: "Monday-Friday, 08.00 AM-18.00 pM"),
    DoctorModel(
        name: "Israa Elshebli",
        type: "Cardiologist",
        location: "Arab Bank, Pr.8, Amman",
        img: "assets/image/doctor.avif",
        about:
            "Israa Elshebli, a dedicated cardiologist, brings a wealth of experience to Golden Gate Cardiology Center in Golden Gate, CA.",
        patient: 2000,
        rating: 4.7,
        review: 1222,
        workingTime: "Monday-Friday, 08.00 AM-18.00 pM"),
    DoctorModel(
        name: "Israa Elshebli",
        type: "Cardiologist",
        location: "Arab Bank, Pr.8, Amman",
        img: "assets/image/doctor.avif",
        about:
            "Israa Elshebli, a dedicated cardiologist, brings a wealth of experience to Golden Gate Cardiology Center in Golden Gate, CA.",
        patient: 2000,
        rating: 4.7,
        review: 1222,
        workingTime: "Monday-Friday, 08.00 AM-18.00 pM"),
    DoctorModel(
        name: "Israa Elshebli",
        type: "Cardiologist",
        location: "Arab Bank, Pr.8, Amman",
        img: "assets/image/doctor.avif",
        about:
            "Israa Elshebli, a dedicated cardiologist, brings a wealth of experience to Golden Gate Cardiology Center in Golden Gate, CA.",
        patient: 2000,
        rating: 4.7,
        review: 1222,
        workingTime: "Monday-Friday, 08.00 AM-18.00 pM"),
  ].obs;
}
