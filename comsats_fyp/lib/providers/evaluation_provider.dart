import 'package:flutter/foundation.dart';
import '../models/evaluation_model.dart';
import '../services/evaluation_service.dart';

class EvaluationProvider extends ChangeNotifier {
  final EvaluationService _service = EvaluationService();

  List<Evaluation> _evaluations = [];
  bool _isLoading = false;

  List<Evaluation> get evaluations => _evaluations;
  bool get isLoading => _isLoading;

  Future<void> load(String teamId) async {
    _isLoading = true;
    notifyListeners();
    _evaluations = await _service.fetchEvaluations(teamId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> submitEvaluation({
    required String teamId,
    required String evaluatorId,
    required String evaluatorName,
    required String evaluationType,
    required List<RubricScore> rubric,
    required String remarks,
  }) async {
    final evaluation = await _service.submitEvaluation(
      teamId: teamId, evaluatorId: evaluatorId, evaluatorName: evaluatorName,
      evaluationType: evaluationType, rubric: rubric, remarks: remarks,
    );
    _evaluations = [..._evaluations, evaluation];
    notifyListeners();
  }
}
