class Staff {
  final String id;
  final String salonId;
  final String fullName;
  final String? profilePhoto;
  final String specialization;
  final String experience;
  final String bio;
  final double rating;

  Staff({
    required this.id,
    required this.salonId,
    required this.fullName,
    this.profilePhoto,
    required this.specialization,
    required this.experience,
    required this.bio,
    this.rating = 0.0,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['id'],
      salonId: json['salon_id'],
      fullName: json['full_name'],
      profilePhoto: json['profile_photo'],
      specialization: json['specialization'],
      experience: json['experience'],
      bio: json['bio'],
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }
}
