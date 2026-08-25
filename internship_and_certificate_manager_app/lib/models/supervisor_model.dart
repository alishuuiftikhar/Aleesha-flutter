class Supervisor {
  final int? id;
  final String name;
  final String? contact;
  final int companyId;

  Supervisor({
    this.id,
    required this.name,
    this.contact,
    required this.companyId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contact': contact,
      'company_id': companyId,
    };
  }

  factory Supervisor.fromMap(Map<String, dynamic> map) {
    return Supervisor(
      id: map['id'],
      name: map['name'],
      contact: map['contact'],
      companyId: map['company_id'],
    );
  }
}
