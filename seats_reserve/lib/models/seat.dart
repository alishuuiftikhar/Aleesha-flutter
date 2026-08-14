class Seat {
  final int id;
  final String seatNumber;
  final String status;
  final DateTime createdAt;

  Seat({
    required this.id,
    required this.seatNumber,
    required this.status,
    required this.createdAt,
  });

  factory Seat.fromMap(Map<String, dynamic> map) {
    return Seat(
      id: map['id'],
      seatNumber: map['seat_number'],
      status: map['status'] ?? 'available',
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
