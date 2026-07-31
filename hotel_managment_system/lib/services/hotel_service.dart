import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/hotel_model.dart';

class HotelService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Fetch all hotels (Search by city or name optional)
  Future<List<Hotel>> getHotels({String query = ''}) async {
    var request = _supabase.from('hotels').select();

    if (query.isNotEmpty) {
      request = request.or('name.ilike.%$query%,city.ilike.%$query%');
    }

    final response = await request.order('created_at', ascending: false);
    return (response as List).map((json) => Hotel.fromJson(json)).toList();
  }

  // Fetch available rooms for a specific hotel
  Future<List<Room>> getRooms(String hotelId) async {
    final response = await _supabase
        .from('rooms')
        .select()
        .eq('hotel_id', hotelId)
        .eq('is_available', true);

    return (response as List).map((json) => Room.fromJson(json)).toList();
  }

  // Create Room Booking
  Future<void> createBooking({
    required String roomId,
    required DateTime checkIn,
    required DateTime checkOut,
    required double totalPrice,
  }) async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception("User not logged in!");

    await _supabase.from('bookings').insert({
      'user_id': user.id,
      'room_id': roomId,
      'check_in': checkIn.toIso8601String().split('T')[0],
      'check_out': checkOut.toIso8601String().split('T')[0],
      'total_price': totalPrice,
      'status': 'confirmed',
    });
  }
}