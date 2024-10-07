class UserWaitingList {
  final int id;
  final int serviceId;
  final int vendorId;
  final String vendorName;
  final String vendorPhoneNumber;
  final String vendorAddress;
  final List<String> vendorImages;
  final String startTime;
  final String endTime;
  final String startDate;
  final String endDate;
  final String message;
  final String status;

  UserWaitingList({
    required this.id,
    required this.serviceId,
    required this.vendorId,
    required this.vendorName,
    required this.vendorPhoneNumber,
    required this.vendorAddress,
    required this.vendorImages,
    required this.startTime,
    required this.endTime,
    required this.startDate,
    required this.endDate,
    required this.message,
    required this.status,
  });

  // Factory method to create an instance from JSON
  factory UserWaitingList.fromJson(Map<String, dynamic> json) {
    return UserWaitingList(
      id: json['id'],
      serviceId: json['serviceId'] ?? 0,
      vendorId: json['vendorId'] ?? 0,
      vendorName: json['vendorName'] ?? '',
      vendorPhoneNumber: json['vendorPhoneNumber'] ?? 0,
      vendorAddress: json['vendorAddress'] ?? '',
      vendorImages: List<String>.from(json['vendorImages'] ?? ''),
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      message: json['message'] ?? '',
      status: json['status'] ?? '',
    );
  }

  // Method to convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceId': serviceId,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'vendorPhoneNumber': vendorPhoneNumber,
      'vendorAddress': vendorAddress,
      'vendorImages': vendorImages,
      'startTime': startTime,
      'endTime': endTime,
      'startDate': startDate,
      'endDate': endDate,
      'message': message,
      'status': status,
    };
  }
}
