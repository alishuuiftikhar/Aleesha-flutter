class Agent {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;
  final String agency;

  Agent({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
    required this.agency,
  });

  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'] ?? '',
      profileImage: json['profile_image'],
      agency: json['agency'] ?? '',
    );
  }
}
