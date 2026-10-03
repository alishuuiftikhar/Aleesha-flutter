enum RepairStatus {
  Received,
  Diagnosing,
  WaitingForParts,
  Repairing,
  Ready,
  Delivered,
  Cancelled
}

class RepairOrder {
  final int? id;
  final int deviceId;
  final int technicianId;
  final String problemDescription;
  final RepairStatus status;
  final double estimatedCost;
  final double finalCost;
  final DateTime createdAt;
  final DateTime updatedAt;

  RepairOrder({
    this.id,
    required this.deviceId,
    required this.technicianId,
    required this.problemDescription,
    required this.status,
    required this.estimatedCost,
    this.finalCost = 0.0,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'device_id': deviceId,
      'technician_id': technicianId,
      'problem_description': problemDescription,
      'status': status.name,
      'estimated_cost': estimatedCost,
      'final_cost': finalCost,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory RepairOrder.fromMap(Map<String, dynamic> map) {
    return RepairOrder(
      id: map['id'],
      deviceId: map['device_id'],
      technicianId: map['technician_id'],
      problemDescription: map['problem_description'],
      status: RepairStatus.values.byName(map['status']),
      estimatedCost: (map['estimated_cost'] as num).toDouble(),
      finalCost: (map['final_cost'] as num).toDouble(),
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}
