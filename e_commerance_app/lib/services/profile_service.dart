import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  ProfileService._();

  static final SupabaseClient _supabase = Supabase.instance.client;

  // Get Profile
  static Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return response;
    } catch (e) {
      print("Get Profile Error: $e");
      return null;
    }
  }

  // Update Profile
  static Future<void> updateProfile({
    required String userId,
    required String fullName,
    required String phone,
    required String address,
    String? email,
    String? profileImage,
  }) async {
    try {
      await _supabase.from('profiles').upsert({
        'id': userId,
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'address': address,
        'profile_image': profileImage,
      });
    } catch (e) {
      throw Exception("Database Update Error: $e");
    }
  }
}
