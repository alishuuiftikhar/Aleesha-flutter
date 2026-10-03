import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/salon_model.dart';
import '../models/service_model.dart';
import '../models/staff_model.dart';

class SalonService {
  final _supabase = Supabase.instance.client;

  Future<List<Salon>> fetchSalons() async {
    try {
      final response = await _supabase.from('salons').select();
      return (response as List).map((json) => Salon.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Service>> fetchServicesBySalon(String salonId) async {
    try {
      final response = await _supabase.from('services').select().eq('salon_id', salonId);
      return (response as List).map((json) => Service.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Staff>> fetchStaffBySalon(String salonId) async {
    try {
      final response = await _supabase.from('staff').select().eq('salon_id', salonId);
      return (response as List).map((json) => Staff.fromJson(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<bool> createBooking({
    required String salonId,
    required String staffId,
    required DateTime date,
    required String time,
    required double price,
    required List<String> serviceIds,
  }) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      await _supabase.from('appointments').insert({
        'customer_id': user.id,
        'salon_id': salonId,
        'staff_id': staffId,
        'appointment_date': date.toIso8601String(),
        'appointment_time': time,
        'total_price': price,
        'status': 'pending',
        'service_ids': serviceIds,
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
