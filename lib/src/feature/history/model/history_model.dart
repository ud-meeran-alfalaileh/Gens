class History {
  final int id;
  final int vendorId;
  final String date;
  final String time;
  final String day;
  final String vendorName;
  final String vendorType;
  final String vendorLocation;
  final String status;
  final int serviceId;
  final String vendorImg;

  History({
    required this.id,
    required this.vendorId,
    required this.date,
    required this.time,
    required this.day,
    required this.vendorName,
    required this.vendorType,
    required this.vendorLocation,
    required this.status,
    required this.serviceId,
    required this.vendorImg,
  });

  // Factory method to create a History object from JSON
  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['bookingId'] ?? 0,
      vendorId: json['vendorId'] ?? 0,
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      day: json['day'] ?? '',
      vendorName: json['vendorName'] ?? '',
      vendorType: json['vendorType'] ?? '',
      vendorLocation: json['vendorLocation'] ?? '',
      status: json['status'] ?? 'Booked',
      serviceId: json['serviceId'] ?? 0,
      vendorImg: json['vendorImg'] ?? 'No Image',
    );
  }
}

class VendorBooking {
  final int id;
  final String userName;
  final String userImage;
  final String userPhoneNumber;
  final String serviceTitle;
  final String date;
  final String startTime;
  final String endTime;
  String status;

  VendorBooking({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.userPhoneNumber,
    required this.serviceTitle,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  // Factory method to create a VendorBooking object from a JSON map
  factory VendorBooking.fromJson(Map<String, dynamic> json) {
    return VendorBooking(
      id: json['bookingId'] ?? 1,
      userName: json['userName'] ?? '',
      userImage: json['userImage'] ?? '',
      userPhoneNumber: json['userPhoneNumber'] ?? '',
      serviceTitle: json['serviceTitle'] ?? '',
      date: json['date'] ?? '',
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      status: json['status'] ?? '',
    );
  }

  // Method to convert a VendorBooking object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'userImage': userImage,
      'userPhoneNumber': userPhoneNumber,
      'serviceTitle': serviceTitle,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
