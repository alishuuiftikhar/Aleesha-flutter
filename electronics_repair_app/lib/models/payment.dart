class Payment {
  final int? id;
  final int repairOrderId;
  final double amount;
  final DateTime paymentDate;
  final String paymentMethod;

  Payment({
    this.id,
    required this.repairOrderId,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'repair_order_id': repairOrderId,
      'amount': amount,
      'payment_date': paymentDate.toIso8601String(),
      'payment_method': paymentMethod,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      id: map['id'],
      repairOrderId: map['repair_order_id'],
      amount: (map['amount'] as num).toDouble(),
      paymentDate: DateTime.parse(map['payment_date']),
      paymentMethod: map['payment_method'],
    );
  }
}
