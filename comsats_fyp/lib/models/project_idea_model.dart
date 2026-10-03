class ProjectIdea {
  final String id;
  final String title;
  final String description;
  final String domain;
  final List<String> techStack;
  final String supervisorId;
  final String supervisorName;
  final int maxTeams;
  final int teamsAssigned;
  final String status; // Open, Closed
  final DateTime postedOn;
  final String difficulty; // Easy, Medium, Hard

  ProjectIdea({
    required this.id,
    required this.title,
    required this.description,
    required this.domain,
    required this.techStack,
    required this.supervisorId,
    required this.supervisorName,
    required this.maxTeams,
    required this.teamsAssigned,
    required this.status,
    required this.postedOn,
    required this.difficulty,
  });

  bool get isOpen => status == 'Open' && teamsAssigned < maxTeams;
}
