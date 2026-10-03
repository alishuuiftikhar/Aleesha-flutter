class Delivery {
  final int? id;
  final String deliveryCompany;
  final String trackingNumber;
  final String packageDescription;
  final String arrivalDate; // YYYY-MM-DD
  final String arrivalTime;
  final String deliveryPersonName;
  final String deliveryPersonPhone;
  final String status; // 'Expected', 'Received', 'Collected', 'Returned'
  final String notes;
  final bool isFavorite;

  Delivery({
    this.id,
    required this.deliveryCompany,
    this.trackingNumber = '',
    this.packageDescription = '',
    required this.arrivalDate,
    this.arrivalTime = '12:00 PM',
    this.deliveryPersonName = '',
    this.deliveryPersonPhone = '',
    this.status = 'Expected',
    this.notes = '',
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'delivery_company': deliveryCompany,
      'tracking_number': trackingNumber,
      'package_description': packageDescription,
      'arrival_date': arrivalDate,
      'arrival_time': arrivalTime,
      'delivery_person_name': deliveryPersonName,
      'delivery_person_phone': deliveryPersonPhone,
      'status': status,
      'notes': notes,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }

  factory Delivery.fromMap(Map<String, dynamic> map) {
    return Delivery(
      id: map['id'] as int?,
      deliveryCompany: map['delivery_company'] as String? ?? '',
      trackingNumber: map['tracking_number'] as String? ?? '',
      packageDescription: map['package_description'] as String? ?? '',
      arrivalDate: map['arrival_date'] as String? ?? '',
      arrivalTime: map['arrival_time'] as String? ?? '',
      deliveryPersonName: map['delivery_person_name'] as String? ?? '',
      deliveryPersonPhone: map['delivery_person_phone'] as String? ?? '',
      status: map['status'] as String? ?? 'Expected',
      notes: map['notes'] as String? ?? '',
      isFavorite: (map['is_favorite'] as int? ?? 0) == 1,
    );
  }

  Delivery copyWith({
    int? id,
    String? deliveryCompany,
    String? trackingNumber,
    String? packageDescription,
    String? arrivalDate,
    String? arrivalTime,
    String? deliveryPersonName,
    String? deliveryPersonPhone,
    String? status,
    String? notes,
    bool? isFavorite,
  }) {
    return Delivery(
      id: id ?? this.id,
      deliveryCompany: deliveryCompany ?? this.deliveryCompany,
      trackingNumber: trackingNumber ?? this.trackingNumber,
      packageDescription: packageDescription ?? this.packageDescription,
      arrivalDate: arrivalDate ?? this.arrivalDate,
      arrivalTime: arrivalTime ?? this.arrivalTime,
      deliveryPersonName: deliveryPersonName ?? this.deliveryPersonName,
      deliveryPersonPhone: deliveryPersonPhone ?? this.deliveryPersonPhone,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
