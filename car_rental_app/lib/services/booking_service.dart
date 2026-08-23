import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<bool> checkAvailability(int carId, DateTime start, DateTime end) async {
    final response = await _supabase
        .from('bookings')
        .select()
        .eq('car_id', carId)
        .or('status.eq.confirmed,status.eq.pending');

    final bookings = response as List;

    for (var booking in bookings) {
      final bStart = DateTime.parse(booking['start_date']);
      final bEnd = DateTime.parse(booking['end_date']);

      // Check for overlap
      if (start.isBefore(bEnd) && end.isAfter(bStart)) {
        return false;
      }
    }
    return true;
  }

  Future<void> createBooking(Map<String, dynamic> bookingData) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('User not logged in');

    final start = DateTime.parse(bookingData['start_date']);
    final end = DateTime.parse(bookingData['end_date']);

    final isAvailable = await checkAvailability(bookingData['car_id'], start, end);
    if (!isAvailable) {
      throw Exception('Car is not available for the selected dates');
    }

    await _supabase.from('bookings').insert({
      ...bookingData,
      'user_id': userId,
      'status': 'confirmed',
      'created_at': DateTime.now().toIso8601String(),
    });
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getUserBookings() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final data = await _supabase
        .from('bookings')
        .select('*, cars(*)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  Future<List<Map<String, dynamic>>> getAllBookings() async {
    final data = await _supabase
        .from('bookings')
        .select('*, cars(*), app_profiles(*)')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(data);
  }

  Future<void> updateBookingStatus(int id, String status) async {
    await _supabase.from('bookings').update({'status': status}).eq('id', id);
    notifyListeners();
  }

  Future<void> cancelBooking(int id) async {
    await _supabase.from('bookings').update({'status': 'cancelled'}).eq('id', id);
    notifyListeners();
  }
}
