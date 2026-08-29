class Booking {
  final int? id;
  final String bookingId;
  final int routeId;
  final String passengerName;
  final String passengerEmail;
  final String passengerPhone;
  final double totalAmount;
  final String bookingDate;
  final String status; // Confirmed, Cancelled

  Booking({
    this.id,
    required this.bookingId,
    required this.routeId,
    required this.passengerName,
    required this.passengerEmail,
    required this.passengerPhone,
    required this.totalAmount,
    required this.bookingDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookingId': bookingId,
      'routeId': routeId,
      'passengerName': passengerName,
      'passengerEmail': passengerEmail,
      'passengerPhone': passengerPhone,
      'totalAmount': totalAmount,
      'bookingDate': bookingDate,
      'status': status,
    };
  }

  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      id: map['id'],
      bookingId: map['bookingId'],
      routeId: map['routeId'],
      passengerName: map['passengerName'],
      passengerEmail: map['passengerEmail'],
      passengerPhone: map['passengerPhone'],
      totalAmount: map['totalAmount'],
      bookingDate: map['bookingDate'],
      status: map['status'],
    );
  }
}

class BookingSeat {
  final int? id;
  final int bookingId;
  final int seatNumber;

  BookingSeat({
    this.id,
    required this.bookingId,
    required this.seatNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookingId': bookingId,
      'seatNumber': seatNumber,
    };
  }

  factory BookingSeat.fromMap(Map<String, dynamic> map) {
    return BookingSeat(
      id: map['id'],
      bookingId: map['bookingId'],
      seatNumber: map['seatNumber'],
    );
  }
}
