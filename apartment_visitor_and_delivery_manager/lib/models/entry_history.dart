class EntryHistory {
  final int? id;
  final String personOrCompany;
  final String type; // 'Visitor Arrival', 'Visitor Departure', 'Delivery Received', 'Package Collected', 'Delivery Returned', 'Maintenance Visit'
  final String date;
  final String time;
  final String status;
  final String details;
  final int? relatedId;

  EntryHistory({
    this.id,
    required this.personOrCompany,
    required this.type,
    required this.date,
    required this.time,
    this.status = 'Completed',
    this.details = '',
    this.relatedId,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'person_or_company': personOrCompany,
      'type': type,
      'date': date,
      'time': time,
      'status': status,
      'details': details,
      'related_id': relatedId,
    };
  }

  factory EntryHistory.fromMap(Map<String, dynamic> map) {
    return EntryHistory(
      id: map['id'] as int?,
      personOrCompany: map['person_or_company'] as String? ?? '',
      type: map['type'] as String? ?? 'General Entry',
      date: map['date'] as String? ?? '',
      time: map['time'] as String? ?? '',
      status: map['status'] as String? ?? 'Completed',
      details: map['details'] as String? ?? '',
      relatedId: map['related_id'] as int?,
    );
  }
}
