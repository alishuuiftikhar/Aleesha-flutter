import '../models/supervision_request_model.dart';
import '../models/team_model.dart';
import 'mock_data_service.dart';

class SupervisionService {
  Future<List<SupervisionRequest>> fetchRequests({String? teamId, String? supervisorId}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var results = List<SupervisionRequest>.from(MockDataService.instance.supervisionRequests);
    if (teamId != null) results = results.where((r) => r.teamId == teamId).toList();
    if (supervisorId != null) results = results.where((r) => r.supervisorId == supervisorId).toList();
    return results;
  }

  Future<SupervisionRequest> sendRequest({
    required Team team,
    required String supervisorId,
    required String supervisorName,
    required String projectTitle,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final req = SupervisionRequest(
      id: 'sr${MockDataService.instance.supervisionRequests.length + 1}',
      teamId: team.id,
      teamName: team.name,
      supervisorId: supervisorId,
      supervisorName: supervisorName,
      projectTitle: projectTitle,
      requestedOn: DateTime.now(),
    );
    MockDataService.instance.supervisionRequests.add(req);
    return req;
  }

  Future<void> respondToRequest(String requestId, bool approve) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final req = MockDataService.instance.supervisionRequests.firstWhere((r) => r.id == requestId);
    req.status = approve ? 'approved' : 'rejected';

    if (approve) {
      final idx = MockDataService.instance.teams.indexWhere((t) => t.id == req.teamId);
      if (idx != -1) {
        final team = MockDataService.instance.teams[idx];
        MockDataService.instance.teams[idx] = team.copyWith(
          projectTitle: req.projectTitle,
          supervisorId: req.supervisorId,
          supervisorName: req.supervisorName,
          supervisionStatus: 'approved',
        );
      }
    }
  }
}
