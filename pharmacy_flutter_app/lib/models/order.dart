import 'medicine.dart';

class OrderModel {
  final String id;
  final String userId;
  final double totalAmount;
  final String status;
  final DateTime createdAt;
  final List<OrderItem>? items;

  OrderModel({
    required this.id,
    required this.userId,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
    this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'].toString(),
      userId: json['user_id'],
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      items: json['order_items'] != null
          ? (json['order_items'] as List).map((i) => OrderItem.fromJson(i)).toList()
          : null,
    );
  }
}

class OrderItem {
  final String id;
  final String orderId;
  final String medicineId;
  final int quantity;
  final double price;
  final Medicine? medicine;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.medicineId,
    required this.quantity,
    required this.price,
    this.medicine,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'].toString(),
      orderId: json['order_id'].toString(),
      medicineId: json['medicine_id'].toString(),
      quantity: json['quantity'],
      price: (json['price'] as num).toDouble(),
      medicine: json['medicines'] != null ? Medicine.fromJson(json['medicines']) : null,
    );
  }
}
