class Profile {
  final String id;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? address;
  final bool isAdmin;

  Profile({
    required this.id,
    this.fullName,
    this.email,
    this.phone,
    this.address,
    this.isAdmin = false,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      isAdmin: json['is_admin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'is_admin': isAdmin,
    };
  }
}
