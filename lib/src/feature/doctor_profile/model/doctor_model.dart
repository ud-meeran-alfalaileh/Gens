class DoctorModel {
  String name;
  String type;
  String img;
  String location;
  String about;
  int patient;
  double rating;
  int review;
  String workingTime;

  DoctorModel({
    required this.name,
    required this.type,
    required this.location,
    required this.img,
    required this.about,
    required this.patient,
    required this.rating,
    required this.review,
    required this.workingTime,
  });
}
