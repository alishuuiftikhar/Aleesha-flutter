enum ComplaintStatus {
  pending,
  assigned,
  inProgress,
  resolved,
  closed
}

extension ComplaintStatusExtension on ComplaintStatus {
  String get name {
    switch (this) {
      case ComplaintStatus.pending: return 'Pending';
      case ComplaintStatus.assigned: return 'Assigned';
      case ComplaintStatus.inProgress: return 'In Progress';
      case ComplaintStatus.resolved: return 'Resolved';
      case ComplaintStatus.closed: return 'Closed';
    }
  }

  static ComplaintStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending': return ComplaintStatus.pending;
      case 'assigned': return ComplaintStatus.assigned;
      case 'in progress': return ComplaintStatus.inProgress;
      case 'resolved': return ComplaintStatus.resolved;
      case 'closed': return ComplaintStatus.closed;
      default: return ComplaintStatus.pending;
    }
  }
}

class Complaint {
  final String id;
  final String userId;
  final String categoryId;
  final String title;
  final String description;
  final String priority;
  final String? imageUrl;
  final ComplaintStatus status;
  final String? assignedTo;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Joined fields
  final String? categoryName;
  final String? userName;

  Complaint({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.title,
    required this.description,
    required this.priority,
    this.imageUrl,
    required this.status,
    this.assignedTo,
    required this.createdAt,
    required this.updatedAt,
    this.categoryName,
    this.userName,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) {
    return Complaint(
      id: json['id'].toString(),
      userId: json['user_id'],
      categoryId: json['category_id'].toString(),
      title: json['title'],
      description: json['description'],
      priority: json['priority'],
      imageUrl: json['image_url'],
      status: ComplaintStatusExtension.fromString(json['status']),
      assignedTo: json['assigned_to'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      categoryName: json['complaint_categories']?['name'],
      userName: json['profiles']?['full_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'category_id': int.parse(categoryId),
      'title': title,
      'description': description,
      'priority': priority,
      'image_url': imageUrl,
      'status': status.name,
      'assigned_to': assignedTo,
    };
  }
}
