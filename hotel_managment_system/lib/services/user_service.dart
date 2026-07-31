import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/hotel_model.dart';

class UserService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Authentication: Sign Up (FIXED: Direct Auth metadata pass kia hai)
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
  }) async {
    final res = await _supabase.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'phone': phone,
      },
    );

    if (res.user == null) {
      throw Exception("Signup failed. Please try again.");
    }
  }

  // Authentication: Login
  Future<void> login(String email, String password) async {
    await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  // Logout
  Future<void> logout() async => await _supabase.auth.signOut();

  // Fetch Hotels with Optional City Search
  Future<List<Hotel>> getHotels({String query = ''}) async {
    var req = _supabase.from('hotels').select();
    if (query.isNotEmpty) {
      req = req.or('name.ilike.%$query%,city.ilike.%$query%');
    }
    final response = await req.order('created_at', ascending: false);
    return (response as List).map((json) => Hotel.fromJson(json)).toList();
  }

  // Fetch Available Rooms for a Hotel
  Future<List<Room>> getRooms(String hotelId) async {
    final response = await _supabase
        .from('rooms')
        .select()
        .eq('hotel_id', hotelId)
        .eq('is_available', true);
    return (response as List).map((json) => Room.fromJson(json)).toList();
  }

  // Book Room
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

  // Fetch User Booking History
  Future<List<Booking>> getMyBookings() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    final response = await _supabase
        .from('bookings')
        .select('''
          id, check_in, check_out, total_price, status,
          rooms ( room_number, room_type, hotels ( name ) )
        ''')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return (response as List).map((json) => Booking.fromJson(json)).toList();
  }
}