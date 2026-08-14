class Product {
  final int? id;
  final String name;
  final String brand;
  final String price;
  final String imagePath;
  final String category;
  final String description;

  Product({
    this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imagePath,
    required this.category,
    required this.description,
  });

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      brand: map['brand'],
      price: map['price'],
      imagePath: map['imagePath'] ?? '',
      category: map['category'],
      description: map['description'] ?? '',
    );
  }
}
