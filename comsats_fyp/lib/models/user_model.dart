enum UserRole { student, supervisor, evaluator, subAdmin, superAdmin }

extension UserRoleX on UserRole {
  String get label {
    switch (this) {
      case UserRole.student:
        return 'Student';
      case UserRole.supervisor:
        return 'Supervisor';
      case UserRole.evaluator:
        return 'Evaluator';
      case UserRole.subAdmin:
        return 'Sub Admin';
      case UserRole.superAdmin:
        return 'Super Admin';
    }
  }
}

class AppUser {
  final String id;
  final String name;
  final String email;
  final String regNumber; // registration / employee number
  final UserRole role;
  final String? avatarUrl;
  final String department;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.regNumber,
    required this.role,
    required this.department,
    this.avatarUrl,
  });
}
