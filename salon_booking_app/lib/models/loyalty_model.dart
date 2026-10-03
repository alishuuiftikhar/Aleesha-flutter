class LoyaltyInfo {
  final int points;
  final String level;
  final List<LoyaltyTransaction> transactions;

  LoyaltyInfo({
    required this.points,
    required this.level,
    required this.transactions,
  });

  String get levelIcon {
    switch (level) {
      case '👑 Glamora VIP': return '👑';
      case '✨ Glam Member': return '✨';
      case '💗 Beauty Lover': return '💗';
      case '🌸 Glow Starter': 
      default: return '🌸';
    }
  }
}

class LoyaltyTransaction {
  final String id;
  final int amount;
  final String description;
  final DateTime date;

  LoyaltyTransaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
  });

  factory LoyaltyTransaction.fromJson(Map<String, dynamic> json) {
    return LoyaltyTransaction(
      id: json['id'],
      amount: json['amount'],
      description: json['description'],
      date: DateTime.parse(json['created_at']),
    );
  }
}
