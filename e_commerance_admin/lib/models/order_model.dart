class OrderModel {
  final int? id;
  final String userId;
  final double totalAmount;
  final String status;
  final String address;
  final DateTime? createdAt;

  OrderModel({
    this.id,
    required this.userId,
    required this.totalAmount,
    required this.status,
    required this.address,
    this.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      userId: json['user_id']?.toString() ?? '',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'pending',
      address: json['address'] ?? 'No Address Provided',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'total_amount': totalAmount,
      'status': status,
      'address': address,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
