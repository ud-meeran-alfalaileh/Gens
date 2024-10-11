class CalendarEvent {
  final String description;
  final int vendorId;
  final String vendorName;
  final String serviceName;
  final DateTime date;
  final int userId;
  final String status;
  final int year;
  final int month;
  final int day;

  CalendarEvent({
    required this.description,
    required this.vendorId,
    required this.vendorName,
    required this.serviceName,
    required this.date,
    required this.userId,
    required this.status,
    required this.year,
    required this.month,
    required this.day,
  });

  // Factory method to create an instance from JSON
  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      description: json['description'],
      vendorId: json['vendorId'],
      vendorName: json['vendorName'],
      serviceName: json['serviceName'],
      date: DateTime.parse(json['date']),
      userId: json['userId'],
      status: json['status'],
      year: json['year'],
      month: json['month'],
      day: json['day'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'vendorId': vendorId,
      'vendorName': vendorName,
      'serviceName': serviceName,
      'date': date,
      'userId': userId,
      'status': status,
      'year': year,
      'month': month,
      'day': day,
    };
  }
}
