class Schedule {
  int id;
  int vendorId;
  String day;
  bool status;
  String openTime;
  String closeTime;

  Schedule({
    required this.id,
    required this.vendorId,
    required this.day,
    required this.status,
    required this.openTime,
    required this.closeTime,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'vendorId': vendorId,
        'day': day,
        'status': status,
        'openTime': openTime,
        'closeTime': closeTime,
      };
}
