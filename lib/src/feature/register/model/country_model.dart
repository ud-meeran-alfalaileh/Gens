class CountryUserModel {
  int id;
  String nameEn;
  String nameAr;
  String pictureThumb;
  String pictureOriginal;

  CountryUserModel({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.pictureThumb,
    required this.pictureOriginal,
  });

  factory CountryUserModel.fromJson(Map<String, dynamic> json) {
    return CountryUserModel(
      id: json['id'],
      nameEn: json['country_name_en']??'',
      nameAr: json['country_name_ar'],
      pictureThumb: json['country_picture_thumb'],
      pictureOriginal: json['country_picture_original'],
    );
  }
}class CountryModel {
  final int id;
  final String nameEn;
  final String nameAr;
  final String pictureThumb;
  final String pictureOriginal;

  CountryModel({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.pictureThumb,
    required this.pictureOriginal,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id'],
      nameEn: json['name_en'] ?? '',
      nameAr: json['name_ar'] ?? '',
      pictureThumb: json['picture_thumb'] ?? '',
      pictureOriginal: json['picture_original'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_en': nameEn,
      'name_ar': nameAr,
      'picture_thumb': pictureThumb,
      'picture_original': pictureOriginal,
    };
  }
}

