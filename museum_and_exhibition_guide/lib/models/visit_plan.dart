class VisitPlan {
  final String id;
  final String museumId;
  final String museumName;
  final DateTime visitDate;
  final String notes;
  final bool isCompleted;

  VisitPlan({
    required this.id,
    required this.museumId,
    required this.museumName,
    required this.visitDate,
    required this.notes,
    this.isCompleted = false,
  });

  factory VisitPlan.fromJson(Map<String, dynamic> json) {
    return VisitPlan(
      id: json['id'],
      museumId: json['museumId'],
      museumName: json['museumName'],
      visitDate: DateTime.parse(json['visitDate']),
      notes: json['notes'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'museumId': museumId,
    'museumName': museumName,
    'visitDate': visitDate.toIso8601String(),
    'notes': notes,
    'isCompleted': isCompleted,
  };

  VisitPlan copyWith({
    String? id,
    String? museumId,
    String? museumName,
    DateTime? visitDate,
    String? notes,
    bool? isCompleted,
  }) {
    return VisitPlan(
      id: id ?? this.id,
      museumId: museumId ?? this.museumId,
      museumName: museumName ?? this.museumName,
      visitDate: visitDate ?? this.visitDate,
      notes: notes ?? this.notes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
