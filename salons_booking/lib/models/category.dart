class ServiceCategory {
  final String id;
  final String name;
  final String icon;

  ServiceCategory({required this.id, required this.name, required this.icon});
}

final List<ServiceCategory> demoCategories = [
  ServiceCategory(id: '1', name: 'Hair', icon: '💇‍♀️'),
  ServiceCategory(id: '2', name: 'Makeup', icon: '💄'),
  ServiceCategory(id: '3', name: 'Nails', icon: '💅'),
  ServiceCategory(id: '4', name: 'Facial', icon: '🧖‍♀️'),
  ServiceCategory(id: '5', name: 'Spa', icon: '💆‍♀️'),
  ServiceCategory(id: '6', name: 'Bridal', icon: '👰'),
];
