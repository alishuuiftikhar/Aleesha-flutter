import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CarService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<Map<String, dynamic>> _cars = [];
  List<Map<String, dynamic>> get cars => _cars;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchCars() async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await _supabase.from('cars').select();
      _cars = List<Map<String, dynamic>>.from(data);
    } catch (e) {
      debugPrint('Error fetching cars: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCar(Map<String, dynamic> carData) async {
    await _supabase.from('cars').insert(carData);
    await fetchCars();
  }

  Future<void> updateCar(int id, Map<String, dynamic> carData) async {
    await _supabase.from('cars').update(carData).eq('id', id);
    await fetchCars();
  }

  Future<void> deleteCar(int id) async {
    await _supabase.from('cars').delete().eq('id', id);
    await fetchCars();
  }

  Future<void> toggleFavorite(int carId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    final existing = await _supabase
        .from('favorites')
        .select()
        .eq('user_id', userId)
        .eq('car_id', carId);

    if ((existing as List).isNotEmpty) {
      await _supabase
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('car_id', carId);
    } else {
      await _supabase.from('favorites').insert({
        'user_id': userId,
        'car_id': carId,
      });
    }
    notifyListeners();
  }

  Future<bool> isFavorite(int carId) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return false;

    final existing = await _supabase
        .from('favorites')
        .select()
        .eq('user_id', userId)
        .eq('car_id', carId);

    return (existing as List).isNotEmpty;
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];

    final data = await _supabase
        .from('favorites')
        .select('*, cars(*)')
        .eq('user_id', userId);

    return (data as List).map((e) => e['cars'] as Map<String, dynamic>).toList();
  }
}
