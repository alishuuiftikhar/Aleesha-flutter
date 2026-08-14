class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String? studentId;
  final String? course;
  final String? profileImage;
  final String role;
  final String status;
  final DateTime createdAt;
  final String? addedBy;
  final String? approvedBy;
  final DateTime? approvedAt;
  final String? addedByName; // To show who added them in Admin panel

  UserProfile({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.studentId,
    this.course,
    this.profileImage,
    required this.role,
    required this.status,
    required this.createdAt,
    this.addedBy,
    this.approvedBy,
    this.approvedAt,
    this.addedByName,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'],
      fullName: map['full_name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      studentId: map['student_id'],
      course: map['course'],
      profileImage: map['profile_image'],
      role: map['role'] ?? 'student',
      status: map['status'] ?? 'pending',
      createdAt: DateTime.parse(map['created_at']),
      addedBy: map['added_by'],
      approvedBy: map['approved_by'],
      approvedAt: map['approved_at'] != null ? DateTime.parse(map['approved_at']) : null,
      addedByName: map['added_by_profiles'] != null ? map['added_by_profiles']['full_name'] : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'student_id': studentId,
      'course': course,
      'profile_image': profileImage,
      'role': role,
      'status': status,
      'added_by': addedBy,
      'approved_by': approvedBy,
      'approved_at': approvedAt?.toIso8601String(),
    };
  }
}
