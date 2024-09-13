class UserModel {
  final int userId;
  final String password;
  final String email;
  final String fName;
  final String secName;
  final String phone;
  final String gender;
  final String userType;
  final String? userImage;
  final bool? logined;
  final bool? disable;
  final bool? locked;

  UserModel({
    required this.userId,
    required this.password,
    required this.email,
    required this.fName,
    required this.secName,
    required this.phone,
    required this.gender,
    required this.userType,
    this.userImage,
    this.logined,
    this.disable,
    this.locked,
  });

  // Factory constructor to create a model from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      password: json['password'],
      email: json['email'] ?? '',
      fName: json['fName'] ?? '',
      secName: json['secName'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      userType: json['userType'] ?? '',
      userImage: json['userImage'] ?? '',
      logined: json['logined'] ?? '',
      disable: json['disable'],
      locked: json['locked'],
    );
  }
}
