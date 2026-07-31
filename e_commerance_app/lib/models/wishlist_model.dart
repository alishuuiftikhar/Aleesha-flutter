class CartModel {
  final int id;
  final String userId;
  final int productId;
  final int quantity;
  final DateTime createdAt;

  CartModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.quantity,
    required this.createdAt,
  });

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['id'] ?? 0,
      userId: map['user_id'] ?? '',
      productId: map['product_id'] ?? 0,
      quantity: map['quantity'] ?? 1,
      createdAt: DateTime.parse(
        map['created_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'quantity': quantity,
      'created_at': createdAt.toIso8601String(),
    };
  }
}