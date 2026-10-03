import 'package:flutter/foundation.dart';
import '../models/team_model.dart';
import '../services/team_service.dart';

class TeamProvider extends ChangeNotifier {
  final TeamService _service = TeamService();

  Team? _myTeam;
  bool _isLoading = false;

  Team? get myTeam => _myTeam;
  bool get isLoading => _isLoading;
  bool get hasTeam => _myTeam != null;

  Future<void> loadMyTeam(String userId) async {
    _isLoading = true;
    notifyListeners();
    _myTeam = await _service.fetchMyTeam(userId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createTeam(String name, TeamMember leader) async {
    _isLoading = true;
    notifyListeners();
    _myTeam = await _service.createTeam(name, leader);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addMember(TeamMember member) async {
    if (_myTeam == null) return;
    _myTeam = await _service.addMember(_myTeam!.id, member);
    notifyListeners();
  }

  void setTeam(Team team) {
    _myTeam = team;
    notifyListeners();
  }
}
