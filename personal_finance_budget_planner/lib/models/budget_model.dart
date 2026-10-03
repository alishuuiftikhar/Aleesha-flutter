class Budget {
  final int? id;
  final int categoryId;
  final double limitAmount;
  final String month; // e.g., '2023-10'

  Budget({
    this.id,
    required this.categoryId,
    required this.limitAmount,
    required this.month,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'limit_amount': limitAmount,
      'month': month,
    };
  }

  factory Budget.fromMap(Map<String, dynamic> map) {
    return Budget(
      id: map['id'],
      categoryId: map['category_id'],
      limitAmount: map['limit_amount'],
      month: map['month'],
    );
  }
}
