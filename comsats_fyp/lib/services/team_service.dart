import '../models/team_model.dart';
import 'mock_data_service.dart';

class TeamService {
  Future<Team?> fetchMyTeam(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return MockDataService.instance.teams.firstWhere(
        (t) => t.members.any((m) => m.id == userId),
      );
    } catch (_) {
      return null;
    }
  }

  Future<Team> createTeam(String name, TeamMember leader) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final team = Team(
      id: 't${MockDataService.instance.teams.length + 1}',
      name: name,
      members: [leader],
    );
    MockDataService.instance.teams.add(team);
    return team;
  }

  Future<Team> addMember(String teamId, TeamMember member) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final idx = MockDataService.instance.teams.indexWhere((t) => t.id == teamId);
    final team = MockDataService.instance.teams[idx];
    final updated = team.copyWith(members: [...team.members, member]);
    MockDataService.instance.teams[idx] = updated;
    return updated;
  }
}
