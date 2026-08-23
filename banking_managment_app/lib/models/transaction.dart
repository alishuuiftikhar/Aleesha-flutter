class Transaction {
  final String id;
  final String fromAccountId;
  final String? toAccountId;
  final double amount;
  final String description;
  final DateTime createdAt;
  final String transactionType; // 'transfer', 'deposit', 'withdrawal'

  Transaction({
    required this.id,
    required this.fromAccountId,
    this.toAccountId,
    required this.amount,
    required this.description,
    required this.createdAt,
    required this.transactionType,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      fromAccountId: json['from_account_id'],
      toAccountId: json['to_account_id'],
      amount: (json['amount'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      transactionType: json['transaction_type'] ?? 'transfer',
    );
  }
}
