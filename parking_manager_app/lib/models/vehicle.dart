class Vehicle {
  final int? id;
  final int? customerId;
  final String plateNumber;
  final String vehicleType;
  final String? model;

  Vehicle({
    this.id,
    this.customerId,
    required this.plateNumber,
    required this.vehicleType,
    this.model,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'plate_number': plateNumber,
      'vehicle_type': vehicleType,
      'model': model,
    };
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'],
      customerId: map['customer_id'],
      plateNumber: map['plate_number'],
      vehicleType: map['vehicle_type'],
      model: map['model'],
    );
  }
}
