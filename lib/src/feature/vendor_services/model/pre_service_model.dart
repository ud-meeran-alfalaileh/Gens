class Prescription {
  final int id;
  final int medicalPrescriptionId;
  final int day;
  final String description;

  Prescription({
    required this.id,
    required this.medicalPrescriptionId,
    required this.day,
    required this.description,
  });

  // Factory method to create an instance from JSON
  factory Prescription.fromJson(Map<String, dynamic> json) {
    return Prescription(
      id: json['id'],
      medicalPrescriptionId: json['medicalPrescriptionId'],
      day: json['day'],
      description: json['description'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'medicalPrescriptionId': medicalPrescriptionId,
      'day': day,
      'description': description,
    };
  }

  // Factory method to parse a list of JSON objects
  static List<Prescription> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => Prescription.fromJson(json)).toList();
  }
}
