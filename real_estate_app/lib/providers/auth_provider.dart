import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../models/profile.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseService _service;
  UserProfile? _profile;
  bool _isLoading = false;

  AuthProvider(this._service) {
    if (_service.currentUser != null) {
      fetchProfile();
    }
    _service.authStateChanges.listen((data) {
      if (data.session != null) {
        fetchProfile();
      } else {
        _profile = null;
        notifyListeners();
      }
    });
  }

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _service.currentUser != null;

  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      _profile = await _service.getProfile();
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.signIn(email, password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password, String fullName) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _service.signUp(email, password, fullName);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _service.signOut();
  }
}
