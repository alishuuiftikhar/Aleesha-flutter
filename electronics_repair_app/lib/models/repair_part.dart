class RepairPart {
  final int? id;
  final int repairOrderId;
  final int partId;
  final int quantity;
  final double priceAtTime;

  RepairPart({
    this.id,
    required this.repairOrderId,
    required this.partId,
    required this.quantity,
    required this.priceAtTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'repair_order_id': repairOrderId,
      'part_id': partId,
      'quantity': quantity,
      'price_at_time': priceAtTime,
    };
  }

  factory RepairPart.fromMap(Map<String, dynamic> map) {
    return RepairPart(
      id: map['id'],
      repairOrderId: map['repair_order_id'],
      partId: map['part_id'],
      quantity: map['quantity'],
      priceAtTime: (map['price_at_time'] as num).toDouble(),
    );
  }
}
