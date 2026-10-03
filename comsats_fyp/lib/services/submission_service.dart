import '../models/submission_model.dart';
import 'mock_data_service.dart';

class SubmissionService {
  Future<List<Submission>> fetchSubmissions(String teamId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockDataService.instance.submissions.where((s) => s.teamId == teamId).toList()
      ..sort((a, b) => b.submittedOn.compareTo(a.submittedOn));
  }

  Future<Submission> submit({
    required String teamId,
    required String type,
    required String fileName,
    required DateTime windowDeadline,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final priorVersions = MockDataService.instance.submissions
        .where((s) => s.teamId == teamId && s.type == type)
        .length;
    final submission = Submission(
      id: 'sub${MockDataService.instance.submissions.length + 1}',
      teamId: teamId,
      type: type,
      fileName: fileName,
      version: priorVersions + 1,
      submittedOn: DateTime.now(),
      windowDeadline: windowDeadline,
      status: 'Submitted',
    );
    MockDataService.instance.submissions.add(submission);
    return submission;
  }
}
