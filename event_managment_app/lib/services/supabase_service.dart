import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event.dart';
import '../models/category.dart';
import '../models/booking.dart';
import '../models/profile.dart';
import '../models/organizer.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // Profiles
  Future<Profile?> getProfile(String id) async {
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', id)
        .single();
    return Profile.fromJson(response);
  }

  Future<void> updateProfile(Profile profile) async {
    await _client.from('profiles').upsert(profile.toJson());
  }

  // Categories
  Future<List<EventCategory>> getCategories() async {
    final response = await _client.from('event_categories').select();
    return (response as List).map((json) => EventCategory.fromJson(json)).toList();
  }

  // Events
  Future<List<Event>> getEvents({String? categoryId, String? searchQuery}) async {
    var query = _client.from('events').select('*, event_categories(*), organizers(*)');
    
    if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }
    
    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.ilike('title', '%$searchQuery%');
    }

    final response = await query.order('date_time', ascending: true);
    return (response as List).map((json) => Event.fromJson(json)).toList();
  }

  Future<Event> getEventDetails(String id) async {
    final response = await _client
        .from('events')
        .select('*, event_categories(*), organizers(*)')
        .eq('id', id)
        .single();
    return Event.fromJson(response);
  }

  // Bookings
  Future<void> createBooking(Booking booking) async {
    // Start a transaction-like process (Supabase handles concurrency better with RPC or triggers)
    // Here we check capacity before booking
    final event = await getEventDetails(booking.eventId);
    if (event.remainingCapacity < booking.quantity) {
      throw Exception('Not enough capacity available');
    }

    await _client.from('bookings').insert(booking.toJson());
    
    // Update remaining capacity
    await _client.from('events').update({
      'remaining_capacity': event.remainingCapacity - booking.quantity
    }).eq('id', booking.eventId);
  }

  Future<List<Booking>> getUserBookings(String userId) async {
    final response = await _client
        .from('bookings')
        .select('*, events(*, event_categories(*), organizers(*))')
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return (response as List).map((json) => Booking.fromJson(json)).toList();
  }

  Future<void> cancelBooking(String bookingId, String eventId, int quantity) async {
    await _client.from('bookings').update({'status': 'cancelled'}).eq('id', bookingId);
    
    final event = await getEventDetails(eventId);
    await _client.from('events').update({
      'remaining_capacity': event.remainingCapacity + quantity
    }).eq('id', eventId);
  }

  // Organizers
  Future<Organizer?> getOrganizer(String userId) async {
    final response = await _client
        .from('organizers')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    return response != null ? Organizer.fromJson(response) : null;
  }

  Future<List<Event>> getOrganizerEvents(String organizerId) async {
    final response = await _client
        .from('events')
        .select('*, event_categories(*), organizers(*)')
        .eq('organizer_id', organizerId)
        .order('date_time', ascending: false);
    return (response as List).map((json) => Event.fromJson(json)).toList();
  }

  Future<void> createEvent(Event event) async {
    await _client.from('events').insert(event.toJson());
  }

  Future<void> updateEvent(Event event) async {
    await _client.from('events').update(event.toJson()).eq('id', event.id);
  }

  Future<void> deleteEvent(String id) async {
    await _client.from('events').delete().eq('id', id);
  }

  Future<List<Booking>> getEventBookings(String eventId) async {
    final response = await _client
        .from('bookings')
        .select('*, profiles(*)')
        .eq('event_id', eventId);
    return (response as List).map((json) => Booking.fromJson(json)).toList();
  }
}
