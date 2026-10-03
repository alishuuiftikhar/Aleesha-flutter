class Device {
  final int? id;
  final int customerId;
  final String type;
  final String model;
  final String serialNumber;

  Device({
    this.id,
    required this.customerId,
    required this.type,
    required this.model,
    required this.serialNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_id': customerId,
      'type': type,
      'model': model,
      'serial_number': serialNumber,
    };
  }

  factory Device.fromMap(Map<String, dynamic> map) {
    return Device(
      id: map['id'],
      customerId: map['customer_id'],
      type: map['type'],
      model: map['model'],
      serialNumber: map['serial_number'],
    );
  }
}
