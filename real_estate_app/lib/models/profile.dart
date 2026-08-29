class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String? avatarUrl;

  UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    this.avatarUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatar_url'],
    );
  }
}
