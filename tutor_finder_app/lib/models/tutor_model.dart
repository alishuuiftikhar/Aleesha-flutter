import 'subject_model.dart';

class TutorModel {
  final String id;
  final String profileId;
  final String bio;
  final String experience;
  final double hourlyRate;
  final double rating;
  final int totalReviews;
  final List<SubjectModel> subjects;
  final String? fullName;
  final String? avatarUrl;

  TutorModel({
    required this.id,
    required this.profileId,
    required this.bio,
    required this.experience,
    required this.hourlyRate,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.subjects = const [],
    this.fullName,
    this.avatarUrl,
  });

  factory TutorModel.fromJson(Map<String, dynamic> json) {
    var subjectsList = json['subjects'] as List? ?? [];
    return TutorModel(
      id: json['id'],
      profileId: json['profile_id'],
      bio: json['bio'] ?? '',
      experience: json['experience'] ?? '',
      hourlyRate: (json['hourly_rate'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
      subjects: subjectsList.map((e) {
        if (e is SubjectModel) return e;
        return SubjectModel.fromJson(e as Map<String, dynamic>);
      }).toList(),
      fullName: json['profiles']?['full_name'],
      avatarUrl: json['profiles']?['avatar_url'],
    );
  }
}
