class Fine {
  final String id;
  final String studentId;
  final String? reservationId;
  final double amount;
  final String reason;
  final String status;
  final DateTime createdAt;
  final DateTime? paidAt;

  Fine({
    required this.id,
    required this.studentId,
    this.reservationId,
    required this.amount,
    required this.reason,
    required this.status,
    required this.createdAt,
    this.paidAt,
  });

  factory Fine.fromMap(Map<String, dynamic> map) {
    return Fine(
      id: map['id'],
      studentId: map['student_id'],
      reservationId: map['reservation_id'],
      amount: (map['amount'] as num).toDouble(),
      reason: map['reason'] ?? '',
      status: map['status'] ?? 'unpaid',
      createdAt: DateTime.parse(map['created_at']),
      paidAt: map['paid_at'] != null ? DateTime.parse(map['paid_at']) : null,
    );
  }
}
