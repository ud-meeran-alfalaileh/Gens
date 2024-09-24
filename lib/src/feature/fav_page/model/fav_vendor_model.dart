class FavVendorModel {
  final int id;
  final int userId;
  final int vendorId;
  final bool isFav;
  final String vendorName;
  final String vendorPhone;
  final String address;
  final String workingTime;
  final double avgRating;
  final int reviewCount;
  final String businessImage;

  FavVendorModel({
    required this.id,
    required this.userId,
    required this.vendorId,
    required this.isFav,
    required this.vendorName,
    required this.vendorPhone,
    required this.address,
    required this.workingTime,
    required this.avgRating,
    required this.reviewCount,
    required this.businessImage,
  });

  // Factory method to create a Vendor object from JSON
  factory FavVendorModel.fromJson(Map<String, dynamic> json) {
    return FavVendorModel(
      id: json['id'],
      userId: json['userId'],
      vendorId: json['vendorId'],
      isFav: json['isFav'],
      vendorName: json['vendorName'],
      vendorPhone: json['vendorPhone'],
      address: json['address'],
      workingTime: json['workingTime'],
      avgRating: json['avgRating'].toDouble(),
      reviewCount: json['reviewCount'],
      businessImage: json['businessImage'],
    );
  }

  // Method to convert a Vendor object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'vendorId': vendorId,
      'isFav': isFav,
      'vendorName': vendorName,
      'vendorPhone': vendorPhone,
      'address': address,
      'workingTime': workingTime,
      'avgRating': avgRating,
      'reviewCount': reviewCount,
      'businessImage': businessImage,
    };
  }
}
