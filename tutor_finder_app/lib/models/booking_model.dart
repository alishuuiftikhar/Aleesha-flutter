import 'tutor_model.dart';
import 'subject_model.dart';

class BookingModel {
  final String id;
  final String studentId;
  final String tutorId;
  final int subjectId;
  final DateTime bookingDate;
  final String startTime;
  final String endTime;
  final String status; // 'pending', 'confirmed', 'completed', 'cancelled'
  final double totalPrice;
  final TutorModel? tutor;
  final SubjectModel? subject;

  final String? studentName;
  final String? studentPhone;
  final String? notes;

  BookingModel({
    required this.id,
    required this.studentId,
    required this.tutorId,
    required this.subjectId,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.totalPrice,
    this.tutor,
    this.subject,
    this.studentName,
    this.studentPhone,
    this.notes,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      studentId: json['student_id'],
      tutorId: json['tutor_id'],
      subjectId: json['subject_id'],
      bookingDate: DateTime.parse(json['booking_date']),
      startTime: json['start_time'],
      endTime: json['end_time'],
      status: json['status'],
      totalPrice: (json['total_price'] ?? 0).toDouble(),
      tutor: json['tutors'] != null 
          ? (json['tutors'] is TutorModel ? json['tutors'] : TutorModel.fromJson(json['tutors'])) 
          : null,
      subject: json['subjects'] != null 
          ? (json['subjects'] is SubjectModel ? json['subjects'] : SubjectModel.fromJson(json['subjects'])) 
          : null,
      studentName: json['student_name'],
      studentPhone: json['student_phone'],
      notes: json['notes'],
    );
  }
}
