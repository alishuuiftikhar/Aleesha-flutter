import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/admin_model.dart';

class AdminService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Admin Login Verification
  Future<Map<String, dynamic>> adminLogin(String email, String password) async {
    try {
      final res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (res.user != null) {
        final profile = await _supabase
            .from('profiles')
            .select('role')
            .eq('id', res.user!.id)
            .single();

        if (profile['role'] == 'admin') {
          return {'success': true, 'error': null};
        } else {
          await _supabase.auth.signOut();
          return {
            'success': false,
            'error': 'Access Denied: You are not an Admin!'
          };
        }
      }
      return {
        'success': false,
        'error': 'Login failed. Please check credentials.'
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString().replaceAll('Exception: ', '')
      };
    }
  }

  // Get All Hotels
  Future<List<Hotel>> getAllHotels() async {
    final response = await _supabase.from('hotels').select();
    return (response as List).map((json) => Hotel.fromJson(json)).toList();
  }

  // Add Hotel
  Future<void> addHotel({
    required String name,
    required String city,
    required String address,
    String? description,
    double rating = 4.5,
    String? imageUrl,
  }) async {
    await _supabase.from('hotels').insert({
      'name': name,
      'city': city,
      'address': address,
      'description': description,
      'rating': rating,
      'image_url': imageUrl,
    });
  }

  // Add Room
  Future<void> addRoom({
    required String hotelId,
    required String roomNumber,
    required String roomType,
    required double pricePerNight,
    required int capacity,
  }) async {
    await _supabase.from('rooms').insert({
      'hotel_id': hotelId,
      'room_number': roomNumber,
      'room_type': roomType,
      'price_per_night': pricePerNight,
      'capacity': capacity,
      'is_available': true,
    });
  }

  // Get Customer Booking Requests
  Future<List<AdminBooking>> getAllCustomerBookings() async {
    final response = await _supabase
        .from('bookings')
        .select('''
          id, check_in, check_out, total_price, status,
          profiles ( full_name, phone ),
          rooms ( room_number, room_type, hotels ( name ) )
        ''')
        .order('created_at', ascending: false);

    return (response as List).map((json) => AdminBooking.fromJson(json)).toList();
  }

  // Get Available Free Rooms
  Future<List<RoomModel>> getAvailableRooms() async {
    final response = await _supabase
        .from('rooms')
        .select()
        .eq('is_available', true);

    return (response as List).map((json) => RoomModel.fromJson(json)).toList();
  }

  // Assign Room & Approve Request (Using Room UUID and marking room unavailable)
  Future<void> assignRoomAndApprove({
    required dynamic bookingId,
    required String roomId,
    required double totalPrice,
  }) async {
    await _supabase.from('bookings').update({
      'room_id': roomId,
      'total_price': totalPrice,
      'status': 'Approved',
    }).eq('id', bookingId);

    await _supabase.from('rooms').update({
      'is_available': false,
    }).eq('id', roomId);
  }
}