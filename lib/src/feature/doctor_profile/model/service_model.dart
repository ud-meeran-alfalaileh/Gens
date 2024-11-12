class Services {
  int serviceId;
  int vendorId;
  String title;
  String description;
  double price;
  String imageUrl;
  String advise;
  bool isVisible;

  Services({
    required this.serviceId,
    required this.vendorId,
    required this.title,
    required this.advise,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.isVisible,
  });

  // Factory constructor to create a Services object from JSON
  factory Services.fromJson(Map<String, dynamic> json) {
    return Services(
      serviceId: json['serviceId'] ?? 0,
      vendorId: json['vendorId'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      advise: json['advise'] ?? '',
      price: (json['price'] != null)
          ? json['price'].toDouble()
          : 0.0, // Handle price properly
      imageUrl: json['imageUrl'] ?? '',
      isVisible: json['isVisible'] ?? false, // Default to false instead of ''
    );
  }

  // Method to convert a Services object to JSON
  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'vendorId': vendorId,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isVisible': isVisible,
    };
  }
}
