class PatientsModel {
  final int userId;
  final String userFName;
  final String userImage;
  final String phoneNumber;

  PatientsModel({
    required this.userId,
    required this.userFName,
    required this.userImage,
    required this.phoneNumber,
  });

  // From JSON
  factory PatientsModel.fromJson(Map<String, dynamic> json) {
    return PatientsModel(
        userId: json['userId']??0,
        userFName: json['userFName'] ?? '',
        userImage: json['userImage'] ?? '',
        phoneNumber: json['phoneNumber']);
  }

  // From List of JSON
  static List<PatientsModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PatientsModel.fromJson(json)).toList();
  }

}
