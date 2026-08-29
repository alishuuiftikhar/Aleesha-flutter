class ServiceRecord {
  final int? id;
  final int vehicleId;
  final String serviceType;
  final DateTime date;
  final int mileage;
  final double cost;
  final String description;
  final DateTime? nextServiceDate;
  final int? nextServiceMileage;

  ServiceRecord({
    this.id,
    required this.vehicleId,
    required this.serviceType,
    required this.date,
    required this.mileage,
    required this.cost,
    required this.description,
    this.nextServiceDate,
    this.nextServiceMileage,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'serviceType': serviceType,
      'date': date.toIso8601String(),
      'mileage': mileage,
      'cost': cost,
      'description': description,
      'nextServiceDate': nextServiceDate?.toIso8601String(),
      'nextServiceMileage': nextServiceMileage,
    };
  }

  factory ServiceRecord.fromMap(Map<String, dynamic> map) {
    return ServiceRecord(
      id: map['id'],
      vehicleId: map['vehicleId'],
      serviceType: map['serviceType'],
      date: DateTime.parse(map['date']),
      mileage: map['mileage'],
      cost: map['cost'],
      description: map['description'],
      nextServiceDate: map['nextServiceDate'] != null
          ? DateTime.parse(map['nextServiceDate'])
          : null,
      nextServiceMileage: map['nextServiceMileage'],
    );
  }
}
