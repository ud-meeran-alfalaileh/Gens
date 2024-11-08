class VendorCalendarModel {
  final int bookingId;
  final String userName;
  final int userId;
  final String serviceTitle;
  final String status;
  final int year;
  final int month;
  final int day;
  final String startTime;
  final String endTime;

  // Constructor
  VendorCalendarModel({
    required this.bookingId,
    required this.userName,
    required this.userId,
    required this.serviceTitle,
    required this.status,
    required this.year,
    required this.month,
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  // Factory method to create a Booking instance from JSON
  factory VendorCalendarModel.fromJson(Map<String, dynamic> json) {
    return VendorCalendarModel(
      bookingId: json['bookingId'],
      userName: json['userName'],
      userId: json['userId'],
      serviceTitle: json['serviceTitle'],
      status: json['status'],
      year: json['year'],
      month: json['month'],
      day: json['day'],
      startTime: json['startTime'],
      endTime: json['endTime'],
    );
  }

  // Method to convert a Booking instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'userName': userName,
      'userId': userId,
      'serviceTitle': serviceTitle,
      'status': status,
      'year': year,
      'month': month,
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  // Method to get the formatted date as a string
  String getFormattedDate() {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

  // Method to get a DateTime object
  DateTime getDateTime() {
    final timeParts = startTime.split(':');
    final hours = int.parse(timeParts[0]);
    final minutes = int.parse(timeParts[1]);
    final seconds = int.parse(timeParts[2]);

    return DateTime(year, month, day, hours, minutes, seconds);
  }
}
