import 'medicine.dart';

class CartItem {
  final String id;
  final String medicineId;
  final String userId;
  final int quantity;
  final Medicine? medicine;

  CartItem({
    required this.id,
    required this.medicineId,
    required this.userId,
    required this.quantity,
    this.medicine,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'].toString(),
      medicineId: json['medicine_id'].toString(),
      userId: json['user_id'],
      quantity: json['quantity'],
      medicine: json['medicines'] != null ? Medicine.fromJson(json['medicines']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medicine_id': medicineId,
      'user_id': userId,
      'quantity': quantity,
    };
  }
}
