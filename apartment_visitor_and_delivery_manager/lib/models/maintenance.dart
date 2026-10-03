class MaintenanceVisit {
  final int? id;
  final String workerName;
  final String serviceType; // 'Plumbing', 'Electrical', 'Internet', 'AC', 'Cleaning', 'Repair', 'Other'
  final String date; // YYYY-MM-DD
  final String time;
  final String apartment;
  final String phoneNumber;
  final String company;
  final String purpose;
  final String status; // 'Scheduled', 'In Progress', 'Completed', 'Cancelled'
  final String notes;
  final bool isFavorite;

  MaintenanceVisit({
    this.id,
    required this.workerName,
    required this.serviceType,
    required this.date,
    this.time = '09:00 AM',
    this.apartment = '',
    this.phoneNumber = '',
    this.company = '',
    this.purpose = '',
    this.status = 'Scheduled',
    this.notes = '',
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'worker_name': workerName,
      'service_type': serviceType,
      'date': date,
      'time': time,
      'apartment': apartment,
      'phone_number': phoneNumber,
      'company': company,
      'purpose': purpose,
      'status': status,
      'notes': notes,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }

  factory MaintenanceVisit.fromMap(Map<String, dynamic> map) {
    return MaintenanceVisit(
      id: map['id'] as int?,
      workerName: map['worker_name'] as String? ?? '',
      serviceType: map['service_type'] as String? ?? 'Other',
      date: map['date'] as String? ?? '',
      time: map['time'] as String? ?? '',
      apartment: map['apartment'] as String? ?? '',
      phoneNumber: map['phone_number'] as String? ?? '',
      company: map['company'] as String? ?? '',
      purpose: map['purpose'] as String? ?? '',
      status: map['status'] as String? ?? 'Scheduled',
      notes: map['notes'] as String? ?? '',
      isFavorite: (map['is_favorite'] as int? ?? 0) == 1,
    );
  }

  MaintenanceVisit copyWith({
    int? id,
    String? workerName,
    String? serviceType,
    String? date,
    String? time,
    String? apartment,
    String? phoneNumber,
    String? company,
    String? purpose,
    String? status,
    String? notes,
    bool? isFavorite,
  }) {
    return MaintenanceVisit(
      id: id ?? this.id,
      workerName: workerName ?? this.workerName,
      serviceType: serviceType ?? this.serviceType,
      date: date ?? this.date,
      time: time ?? this.time,
      apartment: apartment ?? this.apartment,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      company: company ?? this.company,
      purpose: purpose ?? this.purpose,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
