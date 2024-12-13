class NoteModel {
  final int bookingId;
  final String serviceTitle;
  final String? note;
  final String date;

  NoteModel({
    required this.bookingId,
    required this.serviceTitle,
    this.note,
    required this.date,
  });

  // Convert a JSON object to a Booking instance
  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      bookingId: json['bookingId'] ?? 0,
      serviceTitle: json['serviceTitle'] ?? 0,
      note: json['note'] ?? "empty",
      date: json['date'] ?? '',
    );
  }

  static List<NoteModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => NoteModel.fromJson(json)).toList();
  }

  // Convert a Booking instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'serviceTitle': serviceTitle,
      'note': note,
      'date': date,
    };
  }
}
