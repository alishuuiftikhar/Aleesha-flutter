class ComplaintCategory {
  final String id;
  final String name;
  final String? description;

  ComplaintCategory({
    required this.id,
    required this.name,
    this.description,
  });

  factory ComplaintCategory.fromJson(Map<String, dynamic> json) {
    return ComplaintCategory(
      id: json['id'].toString(),
      name: json['name'],
      description: json['description'],
    );
  }
}
