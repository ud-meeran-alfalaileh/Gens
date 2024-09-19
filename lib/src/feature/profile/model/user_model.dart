class UserModel {
  final int userId;
  final String email;
  final String fName;
  final String secName;
  final String phone;
  final String gender;
  final String userType;
  final String? userImage;
  final String dateOfBirth;

  UserModel({
    required this.userId,
    required this.email,
    required this.fName,
    required this.secName,
    required this.phone,
    required this.gender,
    required this.userType,
    required this.dateOfBirth,
    this.userImage,
  });

  // Factory constructor to create a model from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      dateOfBirth: json['dateOfBirth'],
      email: json['email'] ?? '',
      fName: json['fName'] ?? '',
      secName: json['secName'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      userType: json['userType'] ?? '',
      userImage: json['userImage'] ?? '',
    );
  }
}
