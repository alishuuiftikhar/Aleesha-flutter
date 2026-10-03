class RubricScore {
  final String criterion;
  final int score; // out of maxScore
  final int maxScore;

  RubricScore({required this.criterion, required this.score, required this.maxScore});
}

class Evaluation {
  final String id;
  final String teamId;
  final String evaluatorId;
  final String evaluatorName;
  final String evaluationType; // Internal, External
  final List<RubricScore> rubric;
  final String remarks;
  final bool visibleToStudent;
  final DateTime evaluatedOn;

  Evaluation({
    required this.id,
    required this.teamId,
    required this.evaluatorId,
    required this.evaluatorName,
    required this.evaluationType,
    required this.rubric,
    required this.remarks,
    required this.evaluatedOn,
    this.visibleToStudent = true,
  });

  int get totalScore => rubric.fold(0, (sum, r) => sum + r.score);
  int get maxTotalScore => rubric.fold(0, (sum, r) => sum + r.maxScore);
  double get percentage => maxTotalScore == 0 ? 0 : (totalScore / maxTotalScore) * 100;
}
