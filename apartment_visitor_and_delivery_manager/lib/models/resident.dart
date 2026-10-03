class Resident {
  final int? id;
  final String name;
  final String apartmentNumber;
  final String buildingBlock;
  final String phoneNumber;
  final String emergencyContact;
  final String notes;

  Resident({
    this.id,
    required this.name,
    required this.apartmentNumber,
    required this.buildingBlock,
    required this.phoneNumber,
    required this.emergencyContact,
    this.notes = '',
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'apartment_number': apartmentNumber,
      'building_block': buildingBlock,
      'phone_number': phoneNumber,
      'emergency_contact': emergencyContact,
      'notes': notes,
    };
  }

  factory Resident.fromMap(Map<String, dynamic> map) {
    return Resident(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      apartmentNumber: map['apartment_number'] as String? ?? '',
      buildingBlock: map['building_block'] as String? ?? '',
      phoneNumber: map['phone_number'] as String? ?? '',
      emergencyContact: map['emergency_contact'] as String? ?? '',
      notes: map['notes'] as String? ?? '',
    );
  }

  Resident copyWith({
    int? id,
    String? name,
    String? apartmentNumber,
    String? buildingBlock,
    String? phoneNumber,
    String? emergencyContact,
    String? notes,
  }) {
    return Resident(
      id: id ?? this.id,
      name: name ?? this.name,
      apartmentNumber: apartmentNumber ?? this.apartmentNumber,
      buildingBlock: buildingBlock ?? this.buildingBlock,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      notes: notes ?? this.notes,
    );
  }
}
