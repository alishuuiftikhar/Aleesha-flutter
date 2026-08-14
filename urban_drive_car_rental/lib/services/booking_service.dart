import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:urban_drive_car_rental/models/booking.dart';

class BookingService extends ChangeNotifier {
  static final BookingService _instance = BookingService._internal();
  factory BookingService() => _instance;
  BookingService._internal();

  List<Booking> _bookings = [];
  List<Booking> get bookings => _bookings;

  static const String _storageKey = 'user_bookings_v2';

  Future<void> init() async {
    await loadBookings();
  }

  Future<void> loadBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final String? bookingsJson = prefs.getString(_storageKey);
    if (bookingsJson != null) {
      final List<dynamic> decoded = json.decode(bookingsJson);
      _bookings = decoded.map((item) => Booking.fromMap(item)).toList();
      // Sort by latest first
      _bookings.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      notifyListeners();
    }
  }

  Future<void> addBooking(Booking booking) async {
    _bookings.insert(0, booking);
    await _saveToDisk();
    notifyListeners();
  }

  Future<void> _saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(_bookings.map((b) => b.toMap()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  // Filter bookings for a specific user
  List<Booking> getBookingsForUser(String userId) {
    return _bookings.where((b) => b.userId == userId).toList();
  }
}
