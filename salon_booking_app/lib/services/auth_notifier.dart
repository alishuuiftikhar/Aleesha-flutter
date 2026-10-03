import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final Profile? profile;
  final bool isLoading;
  final String? error;

  AuthState({this.profile, this.isLoading = false, this.error});

  AuthState copyWith({Profile? profile, bool? isLoading, String? error}) {
    return AuthState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState()) {
    _init();
  }

  final _supabase = Supabase.instance.client;

  void _init() async {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      await fetchProfile(user.id);
    }
  }

  Future<void> fetchProfile(String userId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      
      if (response == null) {
        state = state.copyWith(error: 'Profile not found. Please contact support.', isLoading: false);
        return;
      }
      
      final profile = Profile.fromJson(response);
      state = state.copyWith(profile: profile, isLoading: false);
    } catch (e) {
      String errorMsg = e.toString();
      if (errorMsg.contains('401') || errorMsg.contains('JWT')) {
        errorMsg = 'Authentication Error: Please check your Supabase Anon Key.';
      }
      state = state.copyWith(error: errorMsg, isLoading: false);
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (response.user != null) {
        await fetchProfile(response.user!.id);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> signUp(String email, String password, String fullName, String phone) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName, 'phone_number': phone, 'role': 'customer'},
      );
      
      // Usually you'd wait for email confirmation or RLS to handle profile creation
      // For simplicity, we assume profile is created by a trigger in Supabase
      if (response.user != null) {
        // fetchProfile(response.user!.id);
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    state = AuthState();
  }
}
