class ReviewPending {
  final int reviewId;
  final String vendorName;
  final String reviewStatus;
  final String serviceTitle;
  final String bookedTime;
  final String bookedDate;
  final String serviceName;
  final String serviceImageUrl;

  ReviewPending({
    required this.reviewId,
    required this.vendorName,
    required this.reviewStatus,
    required this.serviceTitle,
    required this.bookedTime,
    required this.bookedDate,
    required this.serviceName,
    required this.serviceImageUrl,
  });

  // Factory method to create an instance of ReviewPending from JSON
  factory ReviewPending.fromJson(Map<String, dynamic> json) {
    return ReviewPending(
      reviewId: json['reviewId'] ?? '',
      vendorName: json['vendorName'] ?? '',
      reviewStatus: json['reviewStatus'] ?? '',
      serviceTitle: json['serviceTitle'] ?? '',
      bookedTime: json['bookedTime'] ?? '',
      bookedDate: json['bokedDate'] ?? '',
      serviceName: json['serviceName'] ?? '',
      serviceImageUrl: json['serviceImageUrl'] ?? '',
    );
  }

  // Method to convert an instance of ReviewPending to JSON
  Map<String, dynamic> toJson() {
    return {
      'reviewId': reviewId,
      'vendorName': vendorName,
      'reviewStatus': reviewStatus,
      'serviceTitle': serviceTitle,
      'bookedTime': bookedTime,
      'bokedDate': bookedDate,
      'serviceName': serviceName,
      'serviceImageUrl': serviceImageUrl,
    };
  }
}
