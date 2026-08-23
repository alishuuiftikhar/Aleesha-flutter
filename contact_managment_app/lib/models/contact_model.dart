class ContactModel {
  final int? id;
  final String name;
  final String phoneNumber;
  final String? email;
  final String? address;
  final String? notes;
  final String? avatar;
  final int isFavorite;
  final int? groupId;

  ContactModel({
    this.id,
    required this.name,
    required this.phoneNumber,
    this.email,
    this.address,
    this.notes,
    this.avatar,
    this.isFavorite = 0,
    this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'notes': notes,
      'avatar': avatar,
      'isFavorite': isFavorite,
      'groupId': groupId,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      address: map['address'],
      notes: map['notes'],
      avatar: map['avatar'],
      isFavorite: map['isFavorite'],
      groupId: map['groupId'],
    );
  }

  ContactModel copyWith({
    int? id,
    String? name,
    String? phoneNumber,
    String? email,
    String? address,
    String? notes,
    String? avatar,
    int? isFavorite,
    int? groupId,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      notes: notes ?? this.notes,
      avatar: avatar ?? this.avatar,
      isFavorite: isFavorite ?? this.isFavorite,
      groupId: groupId ?? this.groupId,
    );
  }
}
