import '../models/evaluation_model.dart';
import 'mock_data_service.dart';

class EvaluationService {
  Future<List<Evaluation>> fetchEvaluations(String teamId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockDataService.instance.evaluations.where((e) => e.teamId == teamId).toList();
  }

  Future<Evaluation> submitEvaluation({
    required String teamId,
    required String evaluatorId,
    required String evaluatorName,
    required String evaluationType,
    required List<RubricScore> rubric,
    required String remarks,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final evaluation = Evaluation(
      id: 'eval${MockDataService.instance.evaluations.length + 1}',
      teamId: teamId,
      evaluatorId: evaluatorId,
      evaluatorName: evaluatorName,
      evaluationType: evaluationType,
      rubric: rubric,
      remarks: remarks,
      evaluatedOn: DateTime.now(),
    );
    MockDataService.instance.evaluations.add(evaluation);
    return evaluation;
  }
}
