import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  Future<void> signUp(String email, String password, String fullName) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
      
      if (response.user != null) {
        await _supabase.from('app_profiles').upsert({
          'id': response.user!.id,
          'full_name': fullName,
          'email': email,
          'role': 'user',
        });
      }
      notifyListeners();
    } on AuthException catch (e) {
      if (e.message.contains('already registered') || e.code == 'user_already_exists') {
        throw 'This email is already registered. Please go back and Login.';
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }

  Future<Map<String, dynamic>?> getProfile() async {
    if (currentUser == null) return null;
    final response = await _supabase
        .from('app_profiles')
        .select()
        .eq('id', currentUser!.id)
        .single();
    return response;
  }

  Future<void> updateProfile(String fullName) async {
    if (currentUser == null) return;
    await _supabase.from('app_profiles').update({
      'full_name': fullName,
    }).eq('id', currentUser!.id);
    notifyListeners();
  }

  bool get isAdmin => currentUser?.userMetadata?['role'] == 'admin';
}
