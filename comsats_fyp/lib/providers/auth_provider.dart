import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AppUser? _currentUser;
  bool _isLoading = false;
  String? _error;

  AppUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => _currentUser != null;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final user = await _authService.login(email, password);
    _isLoading = false;
    if (user == null) {
      _error = 'Invalid email or password.';
      notifyListeners();
      return false;
    }
    _currentUser = user;
    notifyListeners();
    return true;
  }

  Future<bool> register({
    required String name,
    required String email,
    required String regNumber,
    required String department,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final user = await _authService.register(
        name: name, email: email, regNumber: regNumber, department: department,
      );
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Registration failed. Please try again.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> sendPasswordReset(String email) => _authService.sendPasswordReset(email);

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
