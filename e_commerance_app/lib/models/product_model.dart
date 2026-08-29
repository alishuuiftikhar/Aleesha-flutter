class ProductModel {
  final int id;
  final String name;
  final String imageUrl;
  final double price;
  final String description;
  final int categoryId;

  ProductModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.categoryId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    String rawImage = json['image_url'] ?? json['image'] ?? '';
    String finalUrl = rawImage;

    if (rawImage.isNotEmpty && !rawImage.startsWith('http')) {
      finalUrl = "https://jtwbrngtiihkkzhpjecl.supabase.co/storage/v1/object/public/images/$rawImage";
    }

    return ProductModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      imageUrl: finalUrl,
      price: (json['price'] ?? 0).toDouble(),
      description: json['description'] ?? '',
      categoryId: json['category_id'] ?? 0,
    );
  }
}
