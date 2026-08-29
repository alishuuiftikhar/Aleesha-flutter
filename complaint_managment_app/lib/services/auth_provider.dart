import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';
import '../models/profile_model.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  Profile? _profile;
  bool _isLoading = false;

  Profile? get profile => _profile;
  bool get isLoading => _isLoading;
  User? get currentUser => _supabaseService.currentUser;

  AuthProvider() {
    _init();
  }

  void _init() {
    _supabaseService.authStateChanges.listen((data) async {
      final session = data.session;
      if (session != null) {
        await fetchProfile();
      } else {
        _profile = null;
        notifyListeners();
      }
    });
  }

  Future<void> fetchProfile() async {
    if (currentUser == null) return;
    try {
      _profile = await _supabaseService.getProfile(currentUser!.id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching profile: $e');
    }
  }

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _supabaseService.signIn(email, password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password, String fullName) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _supabaseService.signUp(email, password, fullName);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _supabaseService.signOut();
  }
}
