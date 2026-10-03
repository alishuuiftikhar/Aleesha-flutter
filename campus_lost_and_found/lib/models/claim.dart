enum ClaimStatus {
  pending,
  accepted,
  rejected,
  cancelled
}

class ItemClaim {
  final String id;
  final String itemId;
  final String claimantId;
  final DateTime claimDate;
  final String proofDescription;
  final ClaimStatus status;
  final String? returnMessage;

  ItemClaim({
    required this.id,
    required this.itemId,
    required this.claimantId,
    required this.claimDate,
    required this.proofDescription,
    this.status = ClaimStatus.pending,
    this.returnMessage,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemId': itemId,
      'claimantId': claimantId,
      'claimDate': claimDate.toIso8601String(),
      'proofDescription': proofDescription,
      'status': status.index,
      'returnMessage': returnMessage,
    };
  }

  factory ItemClaim.fromJson(Map<String, dynamic> json) {
    return ItemClaim(
      id: json['id'],
      itemId: json['itemId'],
      claimantId: json['claimantId'],
      claimDate: DateTime.parse(json['claimDate']),
      proofDescription: json['proofDescription'],
      status: ClaimStatus.values[json['status']],
      returnMessage: json['returnMessage'],
    );
  }

  ItemClaim copyWith({
    ClaimStatus? status,
    String? returnMessage,
  }) {
    return ItemClaim(
      id: id,
      itemId: itemId,
      claimantId: claimantId,
      claimDate: claimDate,
      proofDescription: proofDescription,
      status: status ?? this.status,
      returnMessage: returnMessage ?? this.returnMessage,
    );
  }
}
