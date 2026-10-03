import 'service_model.dart';
import 'staff_model.dart';

enum AppointmentStatus { pending, confirmed, completed, cancelled, noShow }

class Appointment {
  final String id;
  final String customerId;
  final String salonId;
  final String staffId;
  final DateTime appointmentDate;
  final String appointmentTime;
  final double totalPrice;
  final AppointmentStatus status;
  final List<String> serviceIds;
  final List<Service>? services; // Joined data
  final Staff? staff;           // Joined data

  Appointment({
    required this.id,
    required this.customerId,
    required this.salonId,
    required this.staffId,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.totalPrice,
    required this.status,
    required this.serviceIds,
    this.services,
    this.staff,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'],
      customerId: json['customer_id'],
      salonId: json['salon_id'],
      staffId: json['staff_id'],
      appointmentDate: DateTime.parse(json['appointment_date']),
      appointmentTime: json['appointment_time'],
      totalPrice: (json['total_price'] ?? 0.0).toDouble(),
      status: AppointmentStatus.values.byName(json['status'] ?? 'pending'),
      serviceIds: List<String>.from(json['service_ids'] ?? []),
      services: json['services'] != null 
          ? (json['services'] as List).map((s) => Service.fromJson(s)).toList() 
          : null,
      staff: json['staff'] != null ? Staff.fromJson(json['staff']) : null,
    );
  }
}
