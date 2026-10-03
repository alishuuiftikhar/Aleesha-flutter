class ParkingSession {
  final int? id;
  final int vehicleId;
  final int spaceId;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final double totalFee;
  final String status;

  ParkingSession({
    this.id,
    required this.vehicleId,
    required this.spaceId,
    required this.checkInTime,
    this.checkOutTime,
    this.totalFee = 0.0,
    this.status = 'active',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicle_id': vehicleId,
      'space_id': spaceId,
      'check_in_time': checkInTime.toIso8601String(),
      'check_out_time': checkOutTime?.toIso8601String(),
      'total_fee': totalFee,
      'status': status,
    };
  }

  factory ParkingSession.fromMap(Map<String, dynamic> map) {
    return ParkingSession(
      id: map['id'],
      vehicleId: map['vehicle_id'],
      spaceId: map['space_id'],
      checkInTime: DateTime.parse(map['check_in_time']),
      checkOutTime: map['check_out_time'] != null ? DateTime.parse(map['check_out_time']) : null,
      totalFee: map['total_fee'] ?? 0.0,
      status: map['status'],
    );
  }
}
