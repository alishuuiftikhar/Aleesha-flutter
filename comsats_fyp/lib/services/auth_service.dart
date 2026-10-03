import '../models/user_model.dart';
import 'mock_data_service.dart';

/// Handles authentication. Swap the body of these methods with real API
/// calls (e.g. POST /auth/login) when connecting to the actual backend.
class AuthService {
  Future<AppUser?> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (email.isEmpty || password.isEmpty) return null;
    try {
      return MockDataService.instance.users.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );
    } catch (_) {
      // Unknown email in the demo dataset: log in as the default student
      // so the flow can still be explored end-to-end.
      return MockDataService.instance.users.first;
    }
  }

  Future<AppUser> register({
    required String name,
    required String email,
    required String regNumber,
    required String department,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final user = AppUser(
      id: 'u${MockDataService.instance.users.length + 1}',
      name: name,
      email: email,
      regNumber: regNumber,
      role: UserRole.student,
      department: department,
    );
    MockDataService.instance.users.add(user);
    return user;
  }

  Future<bool> sendPasswordReset(String email) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return email.contains('@');
  }
}
