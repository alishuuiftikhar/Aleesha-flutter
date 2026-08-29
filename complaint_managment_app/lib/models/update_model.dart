class ComplaintUpdate {
  final String id;
  final String complaintId;
  final String status;
  final String message;
  final String updatedBy;
  final DateTime createdAt;
  final String? updaterName;

  ComplaintUpdate({
    required this.id,
    required this.complaintId,
    required this.status,
    required this.message,
    required this.updatedBy,
    required this.createdAt,
    this.updaterName,
  });

  factory ComplaintUpdate.fromJson(Map<String, dynamic> json) {
    return ComplaintUpdate(
      id: json['id'].toString(),
      complaintId: json['complaint_id'].toString(),
      status: json['status'],
      message: json['message'],
      updatedBy: json['updated_by'],
      createdAt: DateTime.parse(json['created_at']),
      updaterName: json['profiles']?['full_name'],
    );
  }
}
