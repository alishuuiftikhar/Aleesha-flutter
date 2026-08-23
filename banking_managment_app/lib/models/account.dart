class Account {
  final String id;
  final String userId;
  final String accountNumber;
  final double balance;
  final String accountType;

  Account({
    required this.id,
    required this.userId,
    required this.accountNumber,
    required this.balance,
    required this.accountType,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      userId: json['user_id'],
      accountNumber: json['account_number'],
      balance: (json['balance'] ?? 0.0).toDouble(),
      accountType: json['account_type'] ?? 'Savings',
    );
  }
}
