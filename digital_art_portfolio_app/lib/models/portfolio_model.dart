class PortfolioData {
  final Artist artist;
  final List<Artwork> artworks;
  final List<String> categories;

  PortfolioData({
    required this.artist,
    required this.artworks,
    required this.categories,
  });

  factory PortfolioData.fromJson(Map<String, dynamic> json) {
    return PortfolioData(
      artist: Artist.fromJson(json['artist']),
      artworks: (json['artworks'] as List)
          .map((i) => Artwork.fromJson(i))
          .toList(),
      categories: List<String>.from(json['categories']),
    );
  }
}

class Artist {
  final String name;
  final String bio;
  final List<String> skills;
  final List<Service> services;
  final SocialLinks socialLinks;

  Artist({
    required this.name,
    required this.bio,
    required this.skills,
    required this.services,
    required this.socialLinks,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      name: json['name'],
      bio: json['bio'],
      skills: List<String>.from(json['skills']),
      services: (json['services'] as List)
          .map((i) => Service.fromJson(i))
          .toList(),
      socialLinks: SocialLinks.fromJson(json['socialLinks']),
    );
  }
}

class Service {
  final String title;
  final String description;

  Service({required this.title, required this.description});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      title: json['title'],
      description: json['description'],
    );
  }
}

class SocialLinks {
  final String instagram;
  final String twitter;
  final String artstation;
  final String email;

  SocialLinks({
    required this.instagram,
    required this.twitter,
    required this.artstation,
    required this.email,
  });

  factory SocialLinks.fromJson(Map<String, dynamic> json) {
    return SocialLinks(
      instagram: json['instagram'],
      twitter: json['twitter'],
      artstation: json['artstation'],
      email: json['email'],
    );
  }
}

class Artwork {
  final String id;
  final String title;
  final String category;
  final String image;
  final String description;
  bool isFavorite;

  Artwork({
    required this.id,
    required this.title,
    required this.category,
    required this.image,
    required this.description,
    this.isFavorite = false,
  });

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      image: json['image'],
      description: json['description'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'image': image,
      'description': description,
      'isFavorite': isFavorite,
    };
  }
}
