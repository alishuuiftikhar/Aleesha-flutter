import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:logger/logger.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final Logger _logger = Logger();

  Future<AuthResponse?> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      _logger.e('Error signing in: $e');
      rethrow;
    }
  }

  Future<AuthResponse?> signUp(String email, String password, String fullName, String role, String phone) async {
    try {
      _logger.d('Supabase SignUp: email=$email, role=$role');
      
      // Ensure role is exactly what the database expects (lowercase)
      final normalizedRole = role.trim().toLowerCase();
      
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'full_name': fullName,
          'phone': phone,
          'role_name': normalizedRole,
        },
      );
      
      if (response.user == null) {
        throw Exception('Signup successful but user is null. Check email confirmation settings.');
      }
      
      return response;
    } catch (e) {
      _logger.e('Error signing up: $e');
      
      final errorStr = e.toString();
      if (errorStr.contains('401') || errorStr.contains('JWT') || errorStr.contains('invalid')) {
        throw Exception('Invalid API Key: Please check your Supabase Anon Key in lib/utils/constants.dart. It should start with "eyJ...".');
      }
      
      if (errorStr.contains('500') || errorStr.contains('Database error') || errorStr.contains('trigger')) {
        throw Exception('Database Trigger Error: Please check if you have added "admin", "staff", and "customer" to your roles table in Supabase.');
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  User? get currentUser => _supabase.auth.currentUser;
}
