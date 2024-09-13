import 'package:gens/src/feature/doctor_profile/model/doctor_model.dart';

class Review {
  final int id;
  final int userId;
  final String description;
  final int rating;
  final String status;
  final String imgUrl;
  final String userFirstName;
  final String userImage;

  Review({
    required this.id,
    required this.userId,
    required this.description,
    required this.rating,
    required this.status,
    required this.imgUrl,
    required this.userFirstName,
    required this.userImage,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userId: json['userId'],
      description: json['description'] ?? '',
      rating: json['rating'] ?? 0,
      status: json['status'] ?? '',
      imgUrl: json['imgUrl'] ?? '',
      userFirstName: json['userFirstName'] ?? '',
      userImage: json['userImage'] ?? '',
    );
  }
}

// Sample function to parse a list of reviews from JSON
List<Review> parseReviews(List<dynamic> jsonList) {
  return jsonList.map((json) => Review.fromJson(json)).toList();
}

List<BusinessImages> parseImages(List<dynamic> jsonList) {
  return jsonList.map((json) => BusinessImages.fromJson(json)).toList();
}
