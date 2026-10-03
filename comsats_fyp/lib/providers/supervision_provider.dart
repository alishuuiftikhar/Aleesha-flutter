import 'package:flutter/foundation.dart';
import '../models/supervision_request_model.dart';
import '../models/team_model.dart';
import '../services/supervision_service.dart';

class SupervisionProvider extends ChangeNotifier {
  final SupervisionService _service = SupervisionService();

  List<SupervisionRequest> _requests = [];
  bool _isLoading = false;

  List<SupervisionRequest> get requests => _requests;
  bool get isLoading => _isLoading;

  Future<void> loadForTeam(String teamId) async {
    _isLoading = true;
    notifyListeners();
    _requests = await _service.fetchRequests(teamId: teamId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadForSupervisor(String supervisorId) async {
    _isLoading = true;
    notifyListeners();
    _requests = await _service.fetchRequests(supervisorId: supervisorId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> sendRequest({
    required Team team,
    required String supervisorId,
    required String supervisorName,
    required String projectTitle,
  }) async {
    final req = await _service.sendRequest(
      team: team, supervisorId: supervisorId, supervisorName: supervisorName, projectTitle: projectTitle,
    );
    _requests = [..._requests, req];
    notifyListeners();
  }

  Future<void> respond(String requestId, bool approve) async {
    await _service.respondToRequest(requestId, approve);
    final idx = _requests.indexWhere((r) => r.id == requestId);
    if (idx != -1) {
      _requests[idx].status = approve ? 'approved' : 'rejected';
      notifyListeners();
    }
  }
}
