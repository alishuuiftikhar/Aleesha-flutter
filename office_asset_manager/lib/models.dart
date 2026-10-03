class AssetCategory {
  final String id;
  final String name;
  final String icon;

  AssetCategory({required this.id, required this.name, required this.icon});

  factory AssetCategory.fromJson(Map<String, dynamic> json) {
    return AssetCategory(
      id: json['id'],
      name: json['name'],
      icon: json['icon'] ?? 'inventory',
    );
  }
}

class Department {
  final String id;
  final String name;

  Department({required this.id, required this.name});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['id'],
      name: json['name'],
    );
  }
}

class Employee {
  final String id;
  final String fullName;
  final String email;
  final String? departmentId;
  final String? profileImageUrl;

  Employee({
    required this.id,
    required this.fullName,
    required this.email,
    this.departmentId,
    this.profileImageUrl,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      fullName: json['full_name'],
      email: json['email'],
      departmentId: json['department_id'],
      profileImageUrl: json['profile_image_url'],
    );
  }
}

class Asset {
  final String id;
  final String name;
  final String serialNumber;
  final String categoryId;
  final String condition;
  final DateTime purchaseDate;
  final String? assignedTo;
  final String? status; // 'Available', 'Assigned', 'Maintenance'

  Asset({
    required this.id,
    required this.name,
    required this.serialNumber,
    required this.categoryId,
    required this.condition,
    required this.purchaseDate,
    this.assignedTo,
    this.status,
  });

  factory Asset.fromJson(Map<String, dynamic> json) {
    return Asset(
      id: json['id'],
      name: json['name'],
      serialNumber: json['serial_number'],
      categoryId: json['category_id'],
      condition: json['condition'],
      purchaseDate: DateTime.parse(json['purchase_date']),
      assignedTo: json['assigned_to'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'serial_number': serialNumber,
      'category_id': categoryId,
      'condition': condition,
      'purchase_date': purchaseDate.toIso8601String(),
      'assigned_to': assignedTo,
      'status': status,
    };
  }
}

class AssetAssignment {
  final String id;
  final String assetId;
  final String employeeId;
  final String? employeeName;
  final DateTime assignedAt;
  final DateTime? returnedAt;

  AssetAssignment({
    required this.id,
    required this.assetId,
    required this.employeeId,
    this.employeeName,
    required this.assignedAt,
    this.returnedAt,
  });

  factory AssetAssignment.fromJson(Map<String, dynamic> json) {
    return AssetAssignment(
      id: json['id'],
      assetId: json['asset_id'],
      employeeId: json['employee_id'],
      employeeName: json['employees'] != null ? json['employees']['full_name'] : null,
      assignedAt: DateTime.parse(json['assigned_at']),
      returnedAt: json['returned_at'] != null ? DateTime.parse(json['returned_at']) : null,
    );
  }
}

class MaintenanceRecord {
  final String id;
  final String assetId;
  final String? assetName;
  final String description;
  final DateTime date;
  final double cost;

  MaintenanceRecord({
    required this.id,
    required this.assetId,
    this.assetName,
    required this.description,
    required this.date,
    required this.cost,
  });

  factory MaintenanceRecord.fromJson(Map<String, dynamic> json) {
    return MaintenanceRecord(
      id: json['id'],
      assetId: json['asset_id'],
      assetName: json['assets'] != null ? json['assets']['name'] : null,
      description: json['description'],
      date: DateTime.parse(json['maintenance_date']),
      cost: (json['cost'] as num).toDouble(),
    );
  }
}
