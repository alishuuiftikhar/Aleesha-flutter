class AvailabilityModel {
  final int id;
  final String tutorId;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final bool isBooked;

  AvailabilityModel({
    required this.id,
    required this.tutorId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    this.isBooked = false,
  });

  factory AvailabilityModel.fromJson(Map<String, dynamic> json) {
    return AvailabilityModel(
      id: json['id'],
      tutorId: json['tutor_id'],
      dayOfWeek: json['day_of_week'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      isBooked: json['is_booked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tutor_id': tutorId,
      'day_of_week': dayOfWeek,
      'start_time': startTime,
      'end_time': endTime,
    };
  }
}
