import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart';

class DatabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await _supabase.from('service_categories').select();
    return response as List<Map<String, dynamic>>;
  }

  Future<List<Map<String, dynamic>>> getServices({String? categoryName}) async {
    try {
      var query = _supabase.from('services').select('*, service_categories(name)');
      
      if (categoryName != null && categoryName != 'All') {
        // First get category id if filtering by name
        final catRes = await _supabase.from('service_categories').select('id').eq('name', categoryName).single();
        query = query.eq('category_id', catRes['id']);
      }
      
      final response = await query;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Database error fetching services: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getStaffForService(String serviceId) async {
    final response = await _supabase
        .from('staff_services')
        .select('staff:staff_id(*, profiles(*))')
        .eq('service_id', serviceId);
    return response as List<Map<String, dynamic>>;
  }

  Future<void> createBooking(Map<String, dynamic> bookingData) async {
    await _supabase.from('bookings').insert(bookingData);
  }
}
