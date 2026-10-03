import 'package:flutter/foundation.dart';
import '../models/submission_model.dart';
import '../services/submission_service.dart';

class SubmissionProvider extends ChangeNotifier {
  final SubmissionService _service = SubmissionService();

  List<Submission> _submissions = [];
  bool _isLoading = false;

  List<Submission> get submissions => _submissions;
  bool get isLoading => _isLoading;

  Future<void> load(String teamId) async {
    _isLoading = true;
    notifyListeners();
    _submissions = await _service.fetchSubmissions(teamId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> submit({
    required String teamId,
    required String type,
    required String fileName,
    required DateTime windowDeadline,
  }) async {
    final submission = await _service.submit(
      teamId: teamId, type: type, fileName: fileName, windowDeadline: windowDeadline,
    );
    _submissions = [submission, ..._submissions];
    notifyListeners();
  }
}
