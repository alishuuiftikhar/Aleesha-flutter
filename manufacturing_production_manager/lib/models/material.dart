class AppMaterial {
  final String id;
  final String name;
  final String materialCode;
  final double availableQuantity;
  final double minimumStockLevel;
  final String unit;
  final double costPerUnit;

  AppMaterial({
    required this.id,
    required this.name,
    required this.materialCode,
    required this.availableQuantity,
    required this.minimumStockLevel,
    required this.unit,
    required this.costPerUnit,
  });

  factory AppMaterial.fromJson(Map<String, dynamic> json) {
    return AppMaterial(
      id: json['id'].toString(),
      name: json['name'],
      materialCode: json['material_code'],
      availableQuantity: (json['available_quantity'] ?? 0).toDouble(),
      minimumStockLevel: (json['minimum_stock_level'] ?? 0).toDouble(),
      unit: json['unit'] ?? 'pcs',
      costPerUnit: (json['cost_per_unit'] ?? 0).toDouble(),
    );
  }
}
