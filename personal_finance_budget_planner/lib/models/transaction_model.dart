class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final DateTime date;
  final int categoryId;
  final String type; // 'income' or 'expense'
  final String? note;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.categoryId,
    required this.type,
    this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'category_id': categoryId,
      'type': type,
      'note': note,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      amount: map['amount'],
      date: DateTime.parse(map['date']),
      categoryId: map['category_id'],
      type: map['type'],
      note: map['note'],
    );
  }
}
