class Visitor {
  final int? id;
  final String name;
  final String phone;
  final String purpose;
  final String visitDate; // YYYY-MM-DD
  final String expectedArrivalTime;
  final String expectedDepartureTime;
  final String apartment;
  final int numberOfPeople;
  final String vehicleNumber;
  final String notes;
  final String status; // 'Expected', 'Arrived', 'Departed'
  final bool isFavorite;

  Visitor({
    this.id,
    required this.name,
    this.phone = '',
    this.purpose = '',
    required this.visitDate,
    this.expectedArrivalTime = '10:00 AM',
    this.expectedDepartureTime = '12:00 PM',
    this.apartment = '',
    this.numberOfPeople = 1,
    this.vehicleNumber = '',
    this.notes = '',
    this.status = 'Expected',
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'phone': phone,
      'purpose': purpose,
      'visit_date': visitDate,
      'expected_arrival_time': expectedArrivalTime,
      'expected_departure_time': expectedDepartureTime,
      'apartment': apartment,
      'number_of_people': numberOfPeople,
      'vehicle_number': vehicleNumber,
      'notes': notes,
      'status': status,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }

  factory Visitor.fromMap(Map<String, dynamic> map) {
    return Visitor(
      id: map['id'] as int?,
      name: map['name'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      purpose: map['purpose'] as String? ?? '',
      visitDate: map['visit_date'] as String? ?? '',
      expectedArrivalTime: map['expected_arrival_time'] as String? ?? '',
      expectedDepartureTime: map['expected_departure_time'] as String? ?? '',
      apartment: map['apartment'] as String? ?? '',
      numberOfPeople: map['number_of_people'] as int? ?? 1,
      vehicleNumber: map['vehicle_number'] as String? ?? '',
      notes: map['notes'] as String? ?? '',
      status: map['status'] as String? ?? 'Expected',
      isFavorite: (map['is_favorite'] as int? ?? 0) == 1,
    );
  }

  Visitor copyWith({
    int? id,
    String? name,
    String? phone,
    String? purpose,
    String? visitDate,
    String? expectedArrivalTime,
    String? expectedDepartureTime,
    String? apartment,
    int? numberOfPeople,
    String? vehicleNumber,
    String? notes,
    String? status,
    bool? isFavorite,
  }) {
    return Visitor(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      purpose: purpose ?? this.purpose,
      visitDate: visitDate ?? this.visitDate,
      expectedArrivalTime: expectedArrivalTime ?? this.expectedArrivalTime,
      expectedDepartureTime: expectedDepartureTime ?? this.expectedDepartureTime,
      apartment: apartment ?? this.apartment,
      numberOfPeople: numberOfPeople ?? this.numberOfPeople,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
