import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile.dart';
import '../models/membership_plan.dart';
import '../models/membership.dart';

class SupabaseService {
  final SupabaseClient client = Supabase.instance.client;

  // Profiles
  Future<Profile?> getProfile(String id) async {
    final response = await client.from('profiles').select().eq('id', id).single();
    return Profile.fromJson(response);
  }

  Future<void> updateProfile(Profile profile) async {
    await client.from('profiles').update(profile.toJson()).eq('id', profile.id);
  }

  // Membership Plans
  Future<List<MembershipPlan>> getMembershipPlans() async {
    final response = await client.from('membership_plans').select();
    return (response as List).map((e) => MembershipPlan.fromJson(e)).toList();
  }

  // Coaches
  Future<List<Map<String, dynamic>>> getCoaches() async {
    return await client.from('coaches').select();
  }

  // Sports
  Future<List<Map<String, dynamic>>> getSports() async {
    return await client.from('sports').select();
  }

  // Facilities
  Future<List<Map<String, dynamic>>> getFacilities() async {
    return await client.from('facilities').select();
  }

  // Class Bookings
  Future<void> bookClass(String scheduleId, String profileId) async {
    await client.from('class_bookings').insert({
      'schedule_id': scheduleId,
      'profile_id': profileId,
      'status': 'confirmed',
    });
  }

  // Memberships
  Future<Membership?> getUserMembership(String profileId) async {
    try {
      final response = await client
          .from('memberships')
          .select()
          .eq('profile_id', profileId)
          .order('end_date', ascending: false)
          .limit(1)
          .maybeSingle();
      if (response == null) return null;
      return Membership.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // Auth
  User? get currentUser => client.auth.currentUser;
  
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;
}
