class WaitingListModel {
  final int id;
  final int serviceId;
  final int userId;
  final String userName;
  final String userPhoneNumber;
  final String startTime;
  final String endTime;
  final String startDate;
  final String endDate;
  final String? message;
  final String status;

  WaitingListModel({
    required this.id,
    required this.serviceId,
    required this.userId,
    required this.userName,
    required this.userPhoneNumber,
    required this.startTime,
    required this.endTime,
    required this.startDate,
    required this.endDate,
    required this.message,
    required this.status,
  });

  // Method to create a WaitingListModel object from JSON
  factory WaitingListModel.fromJson(Map<String, dynamic> json) {
    return WaitingListModel(
      id: json['id'],
      serviceId: json['serviceId']??0,
      userId: json['userId']??0,
      userName: json['userName']??"",
      userPhoneNumber: json['userPhoneNumber']??0,
      startTime: json['startTime']??0,
      endTime: json['endTime']??0,
      startDate: json['startDate']??"",
      endDate: json['endDate']??"",
      message: json['message']??"",
      status: json['status']??"",
    );
  }

  // Method to convert WaitingListModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceId': serviceId,
      'userId': userId,
      'userName': userName,
      'userPhoneNumber': userPhoneNumber,
      'startTime': startTime,
      'endTime': endTime,
      'startDate': startDate,
      'endDate': endDate,
      'message': message,
      'status': status,
    };
  }
}
