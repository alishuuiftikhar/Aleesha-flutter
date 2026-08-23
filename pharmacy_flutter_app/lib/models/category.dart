class MedicineCategory {
  final String id;
  final String name;
  final String? icon;

  MedicineCategory({
    required this.id,
    required this.name,
    this.icon,
  });

  factory MedicineCategory.fromJson(Map<String, dynamic> json) {
    return MedicineCategory(
      id: json['id'].toString(),
      name: json['name'],
      icon: json['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
    };
  }
}
