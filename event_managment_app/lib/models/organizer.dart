class Organizer {
  final String id;
  final String name;
  final String? bio;
  final String? logoUrl;
  final String userId;

  Organizer({
    required this.id,
    required this.name,
    this.bio,
    this.logoUrl,
    required this.userId,
  });

  factory Organizer.fromJson(Map<String, dynamic> json) {
    return Organizer(
      id: json['id'],
      name: json['name'],
      bio: json['bio'],
      logoUrl: json['logo_url'],
      userId: json['user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'logo_url': logoUrl,
      'user_id': userId,
    };
  }
}
