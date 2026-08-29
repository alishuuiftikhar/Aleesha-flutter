class Reminder {
  final int? id;
  final int vehicleId;
  final String title;
  final DateTime dueDate;
  final int? dueMileage;
  final bool isCompleted;

  Reminder({
    this.id,
    required this.vehicleId,
    required this.title,
    required this.dueDate,
    this.dueMileage,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'title': title,
      'dueDate': dueDate.toIso8601String(),
      'dueMileage': dueMileage,
      'isCompleted': isCompleted ? 1 : 0,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      vehicleId: map['vehicleId'],
      title: map['title'],
      dueDate: DateTime.parse(map['dueDate']),
      dueMileage: map['dueMileage'],
      isCompleted: map['isCompleted'] == 1,
    );
  }
}
