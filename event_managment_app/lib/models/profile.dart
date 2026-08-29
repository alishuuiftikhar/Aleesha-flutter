class Profile {
  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;
  final String? userType; // 'attendee' or 'organizer'

  Profile({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    this.userType,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      email: json['email'],
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'],
      userType: json['user_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'user_type': userType,
    };
  }
}
