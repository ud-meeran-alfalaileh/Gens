class SkinCareModel {
  final String skinTypeMorning;
  final String skinConcerns;
  final String skinIssue;
  final String maritalStatus;
  final String femalePeriodType;
  final String femaleHormoneRelated;
  final String foodConsume;
  final String issuesFrequentlyExperience;
  final String waterConsume;
  final String sleepingHours;
  final String exerciseRoutine;
  final String smokingStatus;
  final String stressLevel;
  final String manageStress;
  final String mainSkincareGoals;
  final String acneMedication;
  final String b12Pills;

  SkinCareModel({
    required this.skinTypeMorning,
    required this.skinConcerns,
    required this.skinIssue,
    required this.maritalStatus,
    required this.femalePeriodType,
    required this.femaleHormoneRelated,
    required this.foodConsume,
    required this.issuesFrequentlyExperience,
    required this.waterConsume,
    required this.sleepingHours,
    required this.exerciseRoutine,
    required this.smokingStatus,
    required this.stressLevel,
    required this.manageStress,
    required this.mainSkincareGoals,
    required this.acneMedication,
    required this.b12Pills,
  });

  // Factory method to create an instance from JSON
  factory SkinCareModel.fromJson(Map<String, dynamic> json) {
    return SkinCareModel(
      skinTypeMorning: json['skinTypeMorning'] ?? '',
      skinConcerns: json['skinConcerns'] ?? '',
      skinIssue: json['skinIssue'] ?? '',
      maritalStatus: json['maritalStatus'] ?? '',
      femalePeriodType: json['femalePeriodType'] ?? '',
      femaleHormoneRelated: json['femaleHormoneRelated'] ?? '',
      foodConsume: json['foodConsume'] ?? '',
      issuesFrequentlyExperience: json['issuesFrequentlyExperience'] ?? '',
      waterConsume: json['waterConsume'] ?? '',
      sleepingHours: json['sleepingHours'] ?? '',
      exerciseRoutine: json['exerciseRoutine'] ?? '',
      smokingStatus: json['smokingStatus'] ?? '',
      stressLevel: json['stressLevel'] ?? '',
      manageStress: json['manageStress'] ?? '',
      mainSkincareGoals: json['mainSkincareGoals'] ?? '',
      acneMedication: json['acneMedication'] ?? '',
      b12Pills: json['b12Pills'] ?? '',
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'skinTypeMorning': skinTypeMorning,
      'skinConcerns': skinConcerns,
      'skinIssue': skinIssue,
      'maritalStatus': maritalStatus,
      'femalePeriodType': femalePeriodType,
      'femaleHormoneRelated': femaleHormoneRelated,
      'foodConsume': foodConsume,
      'issuesFrequentlyExperience': issuesFrequentlyExperience,
      'waterConsume': waterConsume,
      'sleepingHours': sleepingHours,
      'exerciseRoutine': exerciseRoutine,
      'smokingStatus': smokingStatus,
      'stressLevel': stressLevel,
      'manageStress': manageStress,
      'mainSkincareGoals': mainSkincareGoals,
      'acneMedication': acneMedication,
      'b12Pills': b12Pills,
    };
  }
}
