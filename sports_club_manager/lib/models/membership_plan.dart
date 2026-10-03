class MembershipPlan {
  final String id;
  final String name;
  final String description;
  final double price;
  final int durationDays;
  final List<String> benefits;

  MembershipPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationDays,
    required this.benefits,
  });

  factory MembershipPlan.fromJson(Map<String, dynamic> json) {
    return MembershipPlan(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      durationDays: json['duration_days'],
      benefits: List<String>.from(json['benefits'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'duration_days': durationDays,
      'benefits': benefits,
    };
  }
}
