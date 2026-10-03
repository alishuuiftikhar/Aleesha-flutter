class Product {
  final String id;
  final String name;
  final String? productCode;
  final String? categoryId;
  final double sellingPrice;
  final double unitCost;
  final String? imageUrl;
  final String status;

  Product({
    required this.id,
    required this.name,
    this.productCode,
    this.categoryId,
    required this.sellingPrice,
    required this.unitCost,
    this.imageUrl,
    required this.status,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'].toString(),
      name: json['name'],
      productCode: json['product_code'],
      categoryId: json['category_id']?.toString(),
      sellingPrice: (json['selling_price'] ?? 0).toDouble(),
      unitCost: (json['unit_cost'] ?? 0).toDouble(),
      imageUrl: json['image_url'],
      status: json['status'] ?? 'Active',
    );
  }
}
