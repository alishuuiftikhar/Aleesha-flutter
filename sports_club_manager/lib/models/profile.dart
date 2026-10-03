class Profile {
  final String id;
  final String? fullName;
  final String? email;
  final String? avatarUrl;
  final String role; // 'member' or 'admin'
  final DateTime? createdAt;

  Profile({
    required this.id,
    this.fullName,
    this.email,
    this.avatarUrl,
    this.role = 'member',
    this.createdAt,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
      role: json['role'] ?? 'member',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'avatar_url': avatarUrl,
      'role': role,
    };
  }
}
