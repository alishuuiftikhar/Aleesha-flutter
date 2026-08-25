class Internship {
  final int? id;
  final int companyId;
  final int? supervisorId;
  final String position;
  final String department;
  final DateTime startDate;
  final DateTime endDate;
  final String duration;
  final String status; // Planned, Ongoing, Completed, Cancelled
  final String? description;

  Internship({
    this.id,
    required this.companyId,
    this.supervisorId,
    required this.position,
    required this.department,
    required this.startDate,
    required this.endDate,
    required this.duration,
    required this.status,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'company_id': companyId,
      'supervisor_id': supervisorId,
      'position': position,
      'department': department,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'duration': duration,
      'status': status,
      'description': description,
    };
  }

  factory Internship.fromMap(Map<String, dynamic> map) {
    return Internship(
      id: map['id'],
      companyId: map['company_id'],
      supervisorId: map['supervisor_id'],
      position: map['position'],
      department: map['department'],
      startDate: DateTime.parse(map['start_date']),
      endDate: DateTime.parse(map['end_date']),
      duration: map['duration'],
      status: map['status'],
      description: map['description'],
    );
  }

  double calculateProgress() {
    final now = DateTime.now();
    if (now.isBefore(startDate)) return 0.0;
    if (now.isAfter(endDate)) return 1.0;
    
    final totalDuration = endDate.difference(startDate).inSeconds;
    final elapsed = now.difference(startDate).inSeconds;
    
    if (totalDuration == 0) return 0.0;
    return elapsed / totalDuration;
  }
}
