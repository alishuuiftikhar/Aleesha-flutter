class Profile {
  final String id;
  final String? fullName;
  final String? avatarUrl;
  final double? height;
  final double? weight;

  Profile({
    required this.id,
    this.fullName,
    this.avatarUrl,
    this.height,
    this.weight,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'],
      height: json['height'] != null ? (json['height'] as num).toDouble() : null,
      weight: json['weight'] != null ? (json['weight'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'height': height,
      'weight': weight,
    };
  }
}
