class Profile {
  final String id;
  final String email;
  final String fullName;
  final String? avatarUrl;
  final bool isAdmin;
  final DateTime createdAt;

  Profile({
    required this.id,
    required this.email,
    required this.fullName,
    this.avatarUrl,
    this.isAdmin = false,
    required this.createdAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'] ?? '',
      avatarUrl: json['avatar_url'],
      isAdmin: json['is_admin'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'is_admin': isAdmin,
    };
  }
}
