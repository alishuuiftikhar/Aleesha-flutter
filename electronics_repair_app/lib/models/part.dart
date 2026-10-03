class Part {
  final int? id;
  final String name;
  final double price;
  final int stockQuantity;

  Part({
    this.id,
    required this.name,
    required this.price,
    required this.stockQuantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock_quantity': stockQuantity,
    };
  }

  factory Part.fromMap(Map<String, dynamic> map) {
    return Part(
      id: map['id'],
      name: map['name'],
      price: (map['price'] as num).toDouble(),
      stockQuantity: map['stock_quantity'],
    );
  }
}
