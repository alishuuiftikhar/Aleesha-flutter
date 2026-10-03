class SavingsGoal {
  final int? id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final DateTime? deadline;

  SavingsGoal({
    this.id,
    required this.title,
    required this.targetAmount,
    this.currentAmount = 0.0,
    this.deadline,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'target_amount': targetAmount,
      'current_amount': currentAmount,
      'deadline': deadline?.toIso8601String(),
    };
  }

  factory SavingsGoal.fromMap(Map<String, dynamic> map) {
    return SavingsGoal(
      id: map['id'],
      title: map['title'],
      targetAmount: map['target_amount'],
      currentAmount: map['current_amount'],
      deadline: map['deadline'] != null ? DateTime.parse(map['deadline']) : null,
    );
  }
}
