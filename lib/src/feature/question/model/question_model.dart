class QuestionModel {
  String quesstion;
  List<String> answers;
  String type;
  String name;
  String? gender;
  QuestionModel(
      {required this.quesstion,
      required this.answers,
      required this.type,
      required this.name,
      this.gender});
}
