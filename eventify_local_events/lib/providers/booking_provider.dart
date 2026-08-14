import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../services/supabase_service.dart';

class BookingProvider with ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  List<Booking> _bookings = [];
  bool _isLoading = false;

  BookingProvider() {
    loadBookings();
  }

  bool get isLoading => _isLoading;
  List<Booking> get bookings => [..._bookings];
  List<Booking> get upcomingBookings => _bookings.where((b) => b.event.date.isAfter(DateTime.now())).toList();
  List<Booking> get pastBookings => _bookings.where((b) => b.event.date.isBefore(DateTime.now())).toList();

  Future<void> loadBookings() async {
    _isLoading = true;
    notifyListeners();

    _bookings = await _supabaseService.fetchUserBookings();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addBooking(Booking booking) async {
    await _supabaseService.createBooking(booking);
    await loadBookings();
  }
}
