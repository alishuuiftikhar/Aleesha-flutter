import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event_model.dart';
import '../models/booking_model.dart';

class SupabaseService {
  final _supabase = Supabase.instance.client;

  // --- Auth Methods ---

  Future<AuthResponse> signUp(String email, String password) async {
    return await _supabase.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await _supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  User? get currentUser => _supabase.auth.currentUser;

  // --- Event Methods ---

  Future<List<Event>> fetchEvents() async {
    try {
      final response = await _supabase.from('events').select();
      return (response as List).map((data) => _mapToEvent(data)).toList();
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }

  Future<void> createEvent(Event event) async {
    await _supabase.from('events').insert({
      'id': event.id,
      'title': event.title,
      'description': event.description,
      'location': event.location,
      'address': event.address,
      'date': event.date.toIso8601String(),
      'time': event.time,
      'image_url': event.imageUrl,
      'price': event.price,
      'category': event.category,
      'organizer': event.organizer,
      'organizer_image': event.organizerImage,
    });
  }

  // --- Booking Methods ---

  Future<void> createBooking(Booking booking) async {
    await _supabase.from('event_reservations').insert({
      'id': booking.id,
      'event_id': booking.event.id,
      'user_id': currentUser?.id,
      'booking_date': booking.bookingDate.toIso8601String(),
      'ticket_type': booking.ticketType.name,
      'quantity': booking.quantity,
      'total_amount': booking.totalAmount,
      'status': booking.status,
    });
  }

  Future<List<Booking>> fetchUserBookings() async {
    try {
      final response = await _supabase.from('event_reservations').select('*, events(*)').eq('user_id', currentUser?.id ?? '');
      return (response as List).map((data) => _mapToBooking(data)).toList();
    } catch (e) {
      print('Error fetching bookings: $e');
      return [];
    }
  }

  // --- Helpers ---

  Event _mapToEvent(Map<String, dynamic> data) {
    return Event(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      location: data['location'],
      address: data['address'],
      date: DateTime.parse(data['date']),
      time: data['time'],
      imageUrl: data['image_url'],
      price: data['price'].toDouble(),
      category: data['category'],
      organizer: data['organizer'],
      organizerImage: data['organizer_image'],
    );
  }

  Booking _mapToBooking(Map<String, dynamic> data) {
    return Booking(
      id: data['id'],
      event: _mapToEvent(data['events']),
      bookingDate: DateTime.parse(data['booking_date']),
      ticketType: TicketType.values.firstWhere((e) => e.name == data['ticket_type']),
      quantity: data['quantity'],
      totalAmount: data['total_amount'].toDouble(),
      status: data['status'],
    );
  }
}
