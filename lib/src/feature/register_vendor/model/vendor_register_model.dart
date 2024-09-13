class BusinessImages {
  final String imgUrl1;
  final String imgUrl2;
  final String imgUrl3;

  BusinessImages({
    required this.imgUrl1,
    required this.imgUrl2,
    required this.imgUrl3,
  });

  Map<String, String> toJson() {
    return {
      'imgUrl1': imgUrl1,
      'imgUrl2': imgUrl2,
      'imgUrl3': imgUrl3,
    };
  }

  factory BusinessImages.fromJson(Map<String, dynamic> json) {
    return BusinessImages(
      imgUrl1: json['imgUrl1'],
      imgUrl2: json['imgUrl2'],
      imgUrl3: json['imgUrl3'],
    );
  }
}

class VendorRegisterModel {
  final String email;
  final String name;
  final String password;
  final String description;
  final String phone;
  final String userType;
  final String businessLicense;
  final bool status;
  final String address;
  final List<BusinessImages> businessImages;

  VendorRegisterModel({
    required this.email,
    required this.name,
    required this.password,
    required this.description,
    required this.phone,
    required this.userType,
    required this.businessLicense,
    required this.status,
    required this.address,
    required this.businessImages,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'password': password,
      'description': description,
      'phone': phone,
      'userType': userType,
      'businessLicense': businessLicense,
      'status': status,
      'address': address,
      'businessImages': businessImages.map((img) => img.toJson()).toList(),
    };
  }

  factory VendorRegisterModel.fromJson(Map<String, dynamic> json) {
    return VendorRegisterModel(
      email: json['email'],
      name: json['name'],
      password: json['password'],
      description: json['description'],
      phone: json['phone'],
      userType: json['userType'],
      businessLicense: json['businessLicense'],
      status: json['status'],
      address: json['address'],
      businessImages: (json['businessImages'] as List)
          .map((imgJson) => BusinessImages.fromJson(imgJson))
          .toList(),
    );
  }
}
