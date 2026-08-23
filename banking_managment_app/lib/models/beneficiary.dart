class Beneficiary {
  final String id;
  final String userId;
  final String name;
  final String accountNumber;
  final String bankName;

  Beneficiary({
    required this.id,
    required this.userId,
    required this.name,
    required this.accountNumber,
    required this.bankName,
  });

  factory Beneficiary.fromJson(Map<String, dynamic> json) {
    return Beneficiary(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      accountNumber: json['account_number'],
      bankName: json['bank_name'] ?? 'Emerald Bank',
    );
  }
}
