class Look {
  final String id;
  final String title;
  final String description;
  final String image;
  final String category;
  final List<String> items;
  final String tips;
  final double rating;
  final String views;

  Look({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.category,
    required this.items,
    required this.tips,
    required this.rating,
    required this.views,
  });

  factory Look.fromJson(Map<String, dynamic> json) {
    return Look(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      category: json['category'],
      items: List<String>.from(json['items']),
      tips: json['tips'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      views: json['views'] ?? '0',
    );
  }
}

class ClothingItem {
  final String id;
  final String name;
  final String brand;
  final double price;
  final String image;
  final String category;

  ClothingItem({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.image,
    required this.category,
  });

  factory ClothingItem.fromJson(Map<String, dynamic> json) {
    return ClothingItem(
      id: json['id'],
      name: json['name'],
      brand: json['brand'],
      price: json['price'].toDouble(),
      image: json['image'],
      category: json['category'],
    );
  }
}

class Collection {
  final String id;
  final String name;
  final String image;

  Collection({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}

class StyleTip {
  final String title;
  final String content;

  StyleTip({
    required this.title,
    required this.content,
  });

  factory StyleTip.fromJson(Map<String, dynamic> json) {
    return StyleTip(
      title: json['title'],
      content: json['content'],
    );
  }
}

class DailyInspiration {
  final String quote;
  final String author;
  final String image;

  DailyInspiration({
    required this.quote,
    required this.author,
    required this.image,
  });

  factory DailyInspiration.fromJson(Map<String, dynamic> json) {
    return DailyInspiration(
      quote: json['quote'],
      author: json['author'],
      image: json['image'],
    );
  }
}

class LookbookData {
  final List<Look> featuredLooks;
  final List<ClothingItem> items;
  final List<Collection> collections;
  final List<String> categories;
  final List<StyleTip> styleTips;
  final DailyInspiration dailyInspiration;

  LookbookData({
    required this.featuredLooks,
    required this.items,
    required this.collections,
    required this.categories,
    required this.styleTips,
    required this.dailyInspiration,
  });

  factory LookbookData.fromJson(Map<String, dynamic> json) {
    return LookbookData(
      featuredLooks: (json['featured_looks'] as List)
          .map((e) => Look.fromJson(e))
          .toList(),
      items: (json['items'] as List)
          .map((e) => ClothingItem.fromJson(e))
          .toList(),
      collections: (json['collections'] as List)
          .map((e) => Collection.fromJson(e))
          .toList(),
      categories: List<String>.from(json['categories']),
      styleTips: (json['style_tips'] as List)
          .map((e) => StyleTip.fromJson(e))
          .toList(),
      dailyInspiration: DailyInspiration.fromJson(json['daily_inspiration']),
    );
  }
}
