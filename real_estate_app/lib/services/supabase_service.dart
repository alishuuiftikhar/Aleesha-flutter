import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/property.dart';
import '../models/viewing.dart';
import '../models/profile.dart';
import '../models/agent.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  // AUTH
  User? get currentUser => _supabase.auth.currentUser;
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<AuthResponse> signIn(String email, String password) async {
    return await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp(String email, String password, String fullName) async {
    final res = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {'full_name': fullName},
    );
    if (res.user != null) {
      await _supabase.from('profiles').upsert({
        'id': res.user!.id,
        'full_name': fullName,
        'email': email,
      });
    }
    return res;
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // PROFILE
  Future<UserProfile> getProfile() async {
    final data = await _supabase.from('profiles').select().eq('id', currentUser!.id).single();
    return UserProfile.fromJson(data);
  }

  // PROPERTIES
  Future<List<Property>> getProperties({
    String? type,
    String? category,
    String? city,
    double? minPrice,
    double? maxPrice,
    int? minBedrooms,
    int? minBathrooms,
    String? searchQuery,
  }) async {
    var query = _supabase.from('properties').select('*, agents(*), property_images(*)');

    if (type != null) query = query.eq('type', type);
    if (category != null) query = query.eq('category', category);
    if (city != null) query = query.ilike('city', '%$city%');
    if (minPrice != null) query = query.gte('price', minPrice);
    if (maxPrice != null) query = query.lte('price', maxPrice);
    if (minBedrooms != null) query = query.gte('bedrooms', minBedrooms);
    if (minBathrooms != null) query = query.gte('bathrooms', minBathrooms);
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.or('title.ilike.%$searchQuery%,description.ilike.%$searchQuery%,address.ilike.%$searchQuery%');
    }

    final List data = await query.order('created_at', ascending: false);
    
    // Fetch favorites for current user
    List favoriteIds = [];
    if (currentUser != null) {
      final favs = await _supabase.from('favorites').select('property_id').eq('user_id', currentUser!.id);
      favoriteIds = favs.map((e) => e['property_id']).toList();
    }

    return data.map((json) {
      final p = Property.fromJson(json);
      p.isFavorite = favoriteIds.contains(p.id);
      return p;
    }).toList();
  }

  // FAVORITES
  Future<void> toggleFavorite(String propertyId, bool isFavorite) async {
    if (currentUser == null) return;
    if (isFavorite) {
      await _supabase.from('favorites').insert({
        'user_id': currentUser!.id,
        'property_id': propertyId,
      });
    } else {
      await _supabase.from('favorites').delete().eq('user_id', currentUser!.id).eq('property_id', propertyId);
    }
  }

  Future<List<Property>> getFavorites() async {
    if (currentUser == null) return [];
    final favData = await _supabase.from('favorites').select('property_id').eq('user_id', currentUser!.id);
    final List ids = favData.map((e) => e['property_id']).toList();
    if (ids.isEmpty) return [];

    final data = await _supabase.from('properties').select('*, agents(*), property_images(*)').inFilter('id', ids);
    return data.map((json) {
      final p = Property.fromJson(json);
      p.isFavorite = true;
      return p;
    }).toList();
  }

  // VIEWINGS
  Future<List<Viewing>> getViewings() async {
    if (currentUser == null) return [];
    final data = await _supabase
        .from('viewings')
        .select('*, properties(*, agents(*))')
        .eq('user_id', currentUser!.id)
        .order('scheduled_at', ascending: true);
    return data.map((json) => Viewing.fromJson(json)).toList();
  }

  Future<void> scheduleViewing(String propertyId, DateTime scheduledAt) async {
    if (currentUser == null) return;

    // Check for conflicts: Any viewing for this user OR this property within 1 hour of the requested time
    final startTime = scheduledAt.subtract(const Duration(minutes: 59));
    final endTime = scheduledAt.add(const Duration(minutes: 59));

    final conflicts = await _supabase
        .from('viewings')
        .select()
        .or('user_id.eq.${currentUser!.id},property_id.eq.$propertyId')
        .gte('scheduled_at', startTime.toIso8601String())
        .lte('scheduled_at', endTime.toIso8601String())
        .neq('status', 'cancelled');

    if (conflicts.isNotEmpty) {
      throw Exception('Time slot unavailable. Please choose another time.');
    }

    await _supabase.from('viewings').insert({
      'user_id': currentUser!.id,
      'property_id': propertyId,
      'scheduled_at': scheduledAt.toIso8601String(),
      'status': 'confirmed',
    });
  }

  Future<void> cancelViewing(String viewingId) async {
    await _supabase.from('viewings').update({'status': 'cancelled'}).eq('id', viewingId);
  }
}
