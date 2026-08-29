import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../services/database_helper.dart';
import 'package:uuid/uuid.dart';

class BookingProvider with ChangeNotifier {
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> get searchResults => _searchResults;

  List<int> _selectedSeats = [];
  List<int> get selectedSeats => _selectedSeats;

  List<int> _bookedSeats = [];
  List<int> get bookedSeats => _bookedSeats;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> searchBuses(String from, String to, String date) async {
    _isLoading = true;
    notifyListeners();
    _searchResults = await DatabaseHelper.instance.searchRoutes(from, to, date);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadBookedSeats(int routeId) async {
    _bookedSeats = await DatabaseHelper.instance.getBookedSeats(routeId);
    _selectedSeats.clear();
    notifyListeners();
  }

  void toggleSeat(int seatNumber) {
    if (_bookedSeats.contains(seatNumber)) return;
    
    if (_selectedSeats.contains(seatNumber)) {
      _selectedSeats.remove(seatNumber);
    } else {
      _selectedSeats.add(seatNumber);
    }
    notifyListeners();
  }

  Future<int> confirmBooking({
    required int routeId,
    required String name,
    required String email,
    required String phone,
    required double basePrice,
  }) async {
    final bookingId = const Uuid().v4().substring(0, 8).toUpperCase();
    final totalAmount = basePrice * _selectedSeats.length;
    
    final booking = Booking(
      bookingId: bookingId,
      routeId: routeId,
      passengerName: name,
      passengerEmail: email,
      passengerPhone: phone,
      totalAmount: totalAmount,
      bookingDate: DateTime.now().toString(),
      status: 'Confirmed',
    );

    final id = await DatabaseHelper.instance.createBooking(booking, _selectedSeats);
    _selectedSeats.clear();
    notifyListeners();
    return id;
  }
}
