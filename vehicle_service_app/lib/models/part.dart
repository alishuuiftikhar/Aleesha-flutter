class Part {
  final int? id;
  final int serviceRecordId;
  final String name;
  final double cost;

  Part({
    this.id,
    required this.serviceRecordId,
    required this.name,
    required this.cost,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'serviceRecordId': serviceRecordId,
      'name': name,
      'cost': cost,
    };
  }

  factory Part.fromMap(Map<String, dynamic> map) {
    return Part(
      id: map['id'],
      serviceRecordId: map['serviceRecordId'],
      name: map['name'],
      cost: map['cost'],
    );
  }
}
