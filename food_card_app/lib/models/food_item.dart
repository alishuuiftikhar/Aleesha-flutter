class FoodItem {
  final String id;
  final String title;
  final String description;
  final String price;
  final double rating;
  final String imageUrl;
  final String category;
  final String waitTime;
  final bool isFavorite;

  const FoodItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.category,
    required this.waitTime,
    this.isFavorite = false,
  });

  FoodItem copyWith({
    String? id,
    String? title,
    String? description,
    String? price,
    double? rating,
    String? imageUrl,
    String? category,
    String? waitTime,
    bool? isFavorite,
  }) {
    return FoodItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      waitTime: waitTime ?? this.waitTime,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
