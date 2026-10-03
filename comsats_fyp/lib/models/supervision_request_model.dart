class SupervisionRequest {
  final String id;
  final String teamId;
  final String teamName;
  final String supervisorId;
  final String supervisorName;
  final String projectTitle;
  String status; // pending, approved, rejected
  final DateTime requestedOn;

  SupervisionRequest({
    required this.id,
    required this.teamId,
    required this.teamName,
    required this.supervisorId,
    required this.supervisorName,
    required this.projectTitle,
    required this.requestedOn,
    this.status = 'pending',
  });
}
