class AppSettings {
  final int id;
  final String houseName;
  final int totalSeats;
  final String reservationDeadline;
  final double fineAmount;
  final String openingTime;
  final String closingTime;

  AppSettings({
    required this.id,
    required this.houseName,
    required this.totalSeats,
    required this.reservationDeadline,
    required this.fineAmount,
    required this.openingTime,
    required this.closingTime,
  });

  factory AppSettings.fromMap(Map<String, dynamic> map) {
    return AppSettings(
      id: map['id'],
      houseName: map['house_name'] ?? 'SeatSync',
      totalSeats: map['total_seats'] ?? 30,
      reservationDeadline: map['reservation_deadline'] ?? '10:00:00',
      fineAmount: (map['fine_amount'] as num).toDouble(),
      openingTime: map['opening_time'] ?? '09:00:00',
      closingTime: map['closing_time'] ?? '18:00:00',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'house_name': houseName,
      'total_seats': totalSeats,
      'reservation_deadline': reservationDeadline,
      'fine_amount': fineAmount,
      'opening_time': openingTime,
      'closing_time': closingTime,
    };
  }
}
