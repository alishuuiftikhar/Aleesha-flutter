import 'user_model.dart';

class TeamMember {
  final String id;
  final String name;
  final String regNumber;
  final bool isLeader;

  TeamMember({
    required this.id,
    required this.name,
    required this.regNumber,
    this.isLeader = false,
  });
}

class Team {
  final String id;
  final String name;
  final List<TeamMember> members;
  final String? projectId;
  final String? projectTitle;
  final String? supervisorId;
  final String? supervisorName;
  final String supervisionStatus; // none, pending, approved, rejected

  Team({
    required this.id,
    required this.name,
    required this.members,
    this.projectId,
    this.projectTitle,
    this.supervisorId,
    this.supervisorName,
    this.supervisionStatus = 'none',
  });

  Team copyWith({
    String? projectId,
    String? projectTitle,
    String? supervisorId,
    String? supervisorName,
    String? supervisionStatus,
    List<TeamMember>? members,
  }) {
    return Team(
      id: id,
      name: name,
      members: members ?? this.members,
      projectId: projectId ?? this.projectId,
      projectTitle: projectTitle ?? this.projectTitle,
      supervisorId: supervisorId ?? this.supervisorId,
      supervisorName: supervisorName ?? this.supervisorName,
      supervisionStatus: supervisionStatus ?? this.supervisionStatus,
    );
  }
}
