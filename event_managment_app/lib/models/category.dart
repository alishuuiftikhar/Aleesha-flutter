class EventCategory {
  final String id;
  final String name;
  final String icon;

  EventCategory({
    required this.id,
    required this.name,
    required this.icon,
  });

  factory EventCategory.fromJson(Map<String, dynamic> json) {
    return EventCategory(
      id: json['id'],
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
