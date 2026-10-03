enum MembershipStatus { active, expiringSoon, expired, cancelled }

class Membership {
  final String id;
  final String profileId;
  final String planId;
  final DateTime startDate;
  final DateTime endDate;
  final String status;

  Membership({
    required this.id,
    required this.profileId,
    required this.planId,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      id: json['id'],
      profileId: json['profile_id'],
      planId: json['plan_id'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      status: json['status'],
    );
  }

  MembershipStatus get membershipStatus {
    final now = DateTime.now();
    if (status == 'cancelled') return MembershipStatus.cancelled;
    if (now.isAfter(endDate)) return MembershipStatus.expired;
    if (endDate.difference(now).inDays <= 7) return MembershipStatus.expiringSoon;
    return MembershipStatus.active;
  }
}
