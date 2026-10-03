class Reminder {
  final int? id;
  final String title;
  final String description;
  final String reminderDate;
  final String reminderTime;
  final String category; // 'Visitor', 'Delivery', 'Maintenance', 'General'
  final bool isCompleted;

  Reminder({
    this.id,
    required this.title,
    this.description = '',
    required this.reminderDate,
    required this.reminderTime,
    this.category = 'General',
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'reminder_date': reminderDate,
      'reminder_time': reminderTime,
      'category': category,
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'] as int?,
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      reminderDate: map['reminder_date'] as String? ?? '',
      reminderTime: map['reminder_time'] as String? ?? '',
      category: map['category'] as String? ?? 'General',
      isCompleted: (map['is_completed'] as int? ?? 0) == 1,
    );
  }

  Reminder copyWith({
    int? id,
    String? title,
    String? description,
    String? reminderDate,
    String? reminderTime,
    String? category,
    bool? isCompleted,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      reminderDate: reminderDate ?? this.reminderDate,
      reminderTime: reminderTime ?? this.reminderTime,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
