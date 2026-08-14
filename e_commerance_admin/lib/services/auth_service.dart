import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService{

  AuthService._();

  static final SupabaseClient _supabase=
      Supabase.instance.client;

  static User? get currentUser=>
      _supabase.auth.currentUser;

  static Future<AuthResponse> login({
    required String email,
    required String password,
  }) async{

    return await _supabase.auth.signInWithPassword(
      email:email,
      password:password,
    );

  }

  static Future<void> logout() async{

    await _supabase.auth.signOut();

  }

}