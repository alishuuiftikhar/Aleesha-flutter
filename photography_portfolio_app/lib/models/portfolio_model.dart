class PortfolioData {
  final Photographer photographer;
  final List<String> categories;
  final List<PhotoItem> portfolio;
  final List<ServiceItem> services;
  final List<PackageItem> packages;

  PortfolioData({
    required this.photographer,
    required this.categories,
    required this.portfolio,
    required this.services,
    required this.packages,
  });

  factory PortfolioData.fromJson(Map<String, dynamic> json) {
    return PortfolioData(
      photographer: Photographer.fromJson(json['photographer']),
      categories: List<String>.from(json['categories']),
      portfolio: (json['portfolio'] as List).map((i) => PhotoItem.fromJson(i)).toList(),
      services: (json['services'] as List).map((i) => ServiceItem.fromJson(i)).toList(),
      packages: (json['packages'] as List).map((i) => PackageItem.fromJson(i)).toList(),
    );
  }
}

class Photographer {
  final String name;
  final String bio;
  final String profileImage;
  final Map<String, String> contact;

  Photographer({
    required this.name,
    required this.bio,
    required this.profileImage,
    required this.contact,
  });

  factory Photographer.fromJson(Map<String, dynamic> json) {
    return Photographer(
      name: json['name'],
      bio: json['bio'],
      profileImage: json['profile_image'],
      contact: Map<String, String>.from(json['contact']),
    );
  }
}

class PhotoItem {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final String description;
  final bool isFeatured;

  PhotoItem({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.description,
    required this.isFeatured,
  });

  factory PhotoItem.fromJson(Map<String, dynamic> json) {
    return PhotoItem(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      imageUrl: json['image_url'],
      description: json['description'],
      isFeatured: json['is_featured'],
    );
  }
}

class ServiceItem {
  final String title;
  final String description;
  final String startingPrice;

  ServiceItem({
    required this.title,
    required this.description,
    required this.startingPrice,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      title: json['title'],
      description: json['description'],
      startingPrice: json['starting_price'],
    );
  }
}

class PackageItem {
  final String name;
  final String price;
  final List<String> features;

  PackageItem({
    required this.name,
    required this.price,
    required this.features,
  });

  factory PackageItem.fromJson(Map<String, dynamic> json) {
    return PackageItem(
      name: json['name'],
      price: json['price'],
      features: List<String>.from(json['features']),
    );
  }
}
