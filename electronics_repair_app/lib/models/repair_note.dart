class RepairNote {
  final int? id;
  final int repairOrderId;
  final String note;
  final DateTime createdAt;

  RepairNote({
    this.id,
    required this.repairOrderId,
    required this.note,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'repair_order_id': repairOrderId,
      'note': note,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory RepairNote.fromMap(Map<String, dynamic> map) {
    return RepairNote(
      id: map['id'],
      repairOrderId: map['repair_order_id'],
      note: map['note'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
