class Profile {
  final String id;
  final String fullName;
  final String? avatarUrl;
  final String email;

  Profile({
    required this.id,
    required this.fullName,
    this.avatarUrl,
    required this.email,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      fullName: json['full_name'] ?? '',
      avatarUrl: json['avatar_url'],
      email: json['email'] ?? '',
    );
  }
}
