import 'package:gens/src/feature/doctor_profile/model/review_model.dart';

class Vendor {
  final int vendorId;
  final String name;
  final String address;
  final String type;
  final int reviewCount;
  final int numberOfBooking;
  int? fav;
  final List<BusinessImages> images;

  Vendor({
    required this.vendorId,
    required this.name,
    required this.address,
    required this.numberOfBooking,
    required this.reviewCount,
    required this.type,
    required this.images,
  });

  factory Vendor.fromJson(Map<String, dynamic> json) {
    return Vendor(
      vendorId: json['vendorId'] ?? "",
      name: json['name'] ?? "",
      address: json['address'] ?? "",
      numberOfBooking: json['numberOfBooking'] ?? 0,
      reviewCount: json['reviewCount'] ?? 0,
      type: json['type'] ?? "",
      images: parseImages(json['businessImages'] ?? []),
    );
  }
}

class BusinessImages {
  final int id;
  final int vendorID;
  final String imgUrl1;
  final String imgUrl2;
  final String imgUrl3;
  final String vendor;

  BusinessImages({
    required this.id,
    required this.vendorID,
    required this.imgUrl1,
    required this.imgUrl2,
    required this.imgUrl3,
    required this.vendor,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vendorID': vendorID,
      'imgUrl1': imgUrl1,
      'imgUrl2': imgUrl2,
      'imgUrl3': imgUrl3,
    };
  }

  factory BusinessImages.fromJson(Map<String, dynamic> json) {
    return BusinessImages(
        id: json['id'],
        vendorID: json['vendorID'] ?? 0,
        imgUrl1: json['imgUrl1'] ?? '',
        imgUrl2: json['imgUrl2'] ?? '',
        imgUrl3: json['imgUrl3'] ?? '',
        vendor: json['vendor'] ?? '');
  }
}

class DoctorModelById {
  final int vendorId;
  final String name;
  final String type;
  final String location;
  final int pastBookings;
  final double avgRating;
  final int reviewCount;
  final String description;
  final String workingTime;
  final String phone;
  final List<Review> reviews;
  final List<BusinessImages> businessImages;

  DoctorModelById({
    required this.vendorId,
    required this.name,
    required this.type,
    required this.location,
    required this.pastBookings,
    required this.avgRating,
    required this.reviewCount,
    required this.description,
    required this.workingTime,
    required this.reviews,
    required this.businessImages,
    required this.phone,
  });

  factory DoctorModelById.fromJson(Map<String, dynamic> json) {
    return DoctorModelById(
      vendorId: json['vendorId'],
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      phone: json['vendorPhone'] ?? '',
      location: json['location'] ?? '',
      pastBookings: json['pastBookings'] ?? 0,
      avgRating: json['avgRating'].toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      description: json['description'] ?? '',
      workingTime: json['workingTime'] ?? '',
      reviews:
          (json['reviews'] as List).map((e) => Review.fromJson(e)).toList(),
      businessImages: (json['businessImages'] as List)
          .map((e) => BusinessImages.fromJson(e))
          .toList(),
    );
  }
}
