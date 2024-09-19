class UpdateBusinessImageDTO {
  String imgUrl1;
  String imgUrl2;
  String imgUrl3;

  UpdateBusinessImageDTO({
    required this.imgUrl1,
    required this.imgUrl2,
    required this.imgUrl3,
  });

  // Convert the object to JSON
  Map<String, dynamic> toJson() {
    return {
      'imgUrl1': imgUrl1,
      'imgUrl2': imgUrl2,
      'imgUrl3': imgUrl3,
    };
  }
}
