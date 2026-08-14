import 'package:flutter/material.dart';
import 'package:seats_reserve/services/supabase_service.dart';
import 'package:seats_reserve/models/user_profile.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  UserProfile? _userProfile;
  bool _isLoading = false;

  UserProfile? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _supabaseService.currentUser != null;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    if (isAuthenticated) {
      await fetchProfile();
    }
  }

  Future<void> fetchProfile() async {
    final user = _supabaseService.currentUser;
    if (user != null) {
      _isLoading = true;
      notifyListeners();
      
      try {
        _userProfile = await _supabaseService.getProfile(user.id);
      } catch (e) {
        debugPrint('Error fetching profile: $e');
      }

      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _supabaseService.signIn(email: email, password: password);
      await fetchProfile();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    String? studentId,
    String? course,
    String role = 'student',
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _supabaseService.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'phone': phone,
          'student_id': studentId,
          'course': course,
          'role': role,
          'status': role == 'admin' ? 'approved' : 'pending',
        },
      );
      if (response.user != null) {
        await fetchProfile();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _supabaseService.signOut();
    _userProfile = null;
    notifyListeners();
  }
}
