class Submission {
  final String id;
  final String teamId;
  final String type; // Proposal, SRS, Design Document, Progress Report, Final Report
  final String fileName;
  final int version;
  final DateTime submittedOn;
  final DateTime windowDeadline;
  String status; // Submitted, Under Review, Revision Requested, Approved
  String? feedback;

  Submission({
    required this.id,
    required this.teamId,
    required this.type,
    required this.fileName,
    required this.version,
    required this.submittedOn,
    required this.windowDeadline,
    this.status = 'Submitted',
    this.feedback,
  });

  bool get isLate => submittedOn.isAfter(windowDeadline);
}
