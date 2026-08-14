class Contact {
  final String? id;
  final String name;
  final String jobTitle;
  final String phone;
  final String email;
  final String? website;
  final String? avatarUrl;
  final DateTime createdAt;

  Contact({
    this.id,
    required this.name,
    required this.jobTitle,
    required this.phone,
    required this.email,
    this.website,
    this.avatarUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'job_title': jobTitle,
      'phone': phone,
      'email': email,
      'website': website,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id']?.toString(),
      name: map['name'] ?? '',
      jobTitle: map['job_title'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      website: map['website'],
      avatarUrl: map['avatar_url'],
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : DateTime.now(),
    );
  }

  Contact copyWith({
    String? id,
    String? name,
    String? jobTitle,
    String? phone,
    String? email,
    String? website,
    String? avatarUrl,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      jobTitle: jobTitle ?? this.jobTitle,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: this.createdAt,
    );
  }
}
