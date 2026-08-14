import 'package:seats_reserve/models/user_profile.dart';
import 'package:seats_reserve/models/seat.dart';

class Reservation {
  final String id;
  final String studentId;
  final int seatId;
  final DateTime reservationDate;
  final DateTime reservedAt;
  final String status;
  final DateTime createdAt;
  
  // Joined fields
  final UserProfile? student;
  final Seat? seat;

  Reservation({
    required this.id,
    required this.studentId,
    required this.seatId,
    required this.reservationDate,
    required this.reservedAt,
    required this.status,
    required this.createdAt,
    this.student,
    this.seat,
  });

  factory Reservation.fromMap(Map<String, dynamic> map) {
    return Reservation(
      id: map['id'],
      studentId: map['student_id'],
      seatId: map['seat_id'],
      reservationDate: DateTime.parse(map['reservation_date']),
      reservedAt: DateTime.parse(map['reserved_at']),
      status: map['status'] ?? 'reserved',
      createdAt: DateTime.parse(map['created_at']),
      student: map['profiles'] != null ? UserProfile.fromMap(map['profiles']) : null,
      seat: map['seats'] != null ? Seat.fromMap(map['seats']) : null,
    );
  }
}
