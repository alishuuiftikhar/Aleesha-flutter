enum ItemCategory {
  electronics,
  books,
  stationery,
  keys,
  bags,
  clothing,
  accessories,
  idCards,
  other
}

enum ItemStatus {
  reported,
  underReview,
  potentialMatch,
  claimRequested,
  returned,
  closed
}

enum ReportType {
  lost,
  found
}

class LostFoundItem {
  final String id;
  final String name;
  final ItemCategory category;
  final ReportType type;
  final String location;
  final DateTime dateTime;
  final String description;
  final String identifyingDetails;
  final String? imagePath;
  final ItemStatus status;
  final String reporterId;
  final bool isFavorite;

  LostFoundItem({
    required this.id,
    required this.name,
    required this.category,
    required this.type,
    required this.location,
    required this.dateTime,
    required this.description,
    required this.identifyingDetails,
    this.imagePath,
    this.status = ItemStatus.reported,
    required this.reporterId,
    this.isFavorite = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category.index,
      'type': type.index,
      'location': location,
      'dateTime': dateTime.toIso8601String(),
      'description': description,
      'identifyingDetails': identifyingDetails,
      'imagePath': imagePath,
      'status': status.index,
      'reporterId': reporterId,
      'isFavorite': isFavorite,
    };
  }

  factory LostFoundItem.fromJson(Map<String, dynamic> json) {
    return LostFoundItem(
      id: json['id'],
      name: json['name'],
      category: ItemCategory.values[json['category']],
      type: ReportType.values[json['type']],
      location: json['location'],
      dateTime: DateTime.parse(json['dateTime']),
      description: json['description'],
      identifyingDetails: json['identifyingDetails'],
      imagePath: json['imagePath'],
      status: ItemStatus.values[json['status']],
      reporterId: json['reporterId'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  LostFoundItem copyWith({
    String? name,
    ItemCategory? category,
    ReportType? type,
    String? location,
    DateTime? dateTime,
    String? description,
    String? identifyingDetails,
    String? imagePath,
    ItemStatus? status,
    bool? isFavorite,
  }) {
    return LostFoundItem(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      type: type ?? this.type,
      location: location ?? this.location,
      dateTime: dateTime ?? this.dateTime,
      description: description ?? this.description,
      identifyingDetails: identifyingDetails ?? this.identifyingDetails,
      imagePath: imagePath ?? this.imagePath,
      status: status ?? this.status,
      reporterId: reporterId,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
