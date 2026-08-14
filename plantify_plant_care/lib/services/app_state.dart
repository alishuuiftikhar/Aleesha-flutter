import 'package:flutter/material.dart';
import '../models/plant.dart';

class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  final List<Plant> _cart = [];
  final List<Plant> _favorites = [];
  final List<Map<String, dynamic>> _reminders = [
    {
      'plant': Plant(id: 'i1', name: 'Snake Plant', species: 'Sansevieria', category: 'Indoor', description: 'Hardy.', imageUrl: 'https://images.unsplash.com/photo-1593482892290-f54927ae1bb6?q=80&w=500', price: '\$25.00', water: 'Low', light: 'Low', humidity: 'Low', temperature: '18-27°C'),
      'time': 'Daily at 9:00 AM'
    },
    {
      'plant': Plant(id: 'f5', name: 'Exotic Orchid', species: 'Phalaenopsis', category: 'Flowers', description: 'Elegant.', imageUrl: 'https://images.unsplash.com/photo-1566333306171-77e926550f8d?q=80&w=500', price: '\$45.00', water: 'Mist', light: 'Indirect', humidity: 'High', temperature: '20-25°C'),
      'time': 'Every Monday'
    },
    {
      'plant': Plant(id: 'o2', name: 'Garden Lavender', species: 'Lavandula', category: 'Outdoor', description: 'Aromatic.', imageUrl: 'https://images.unsplash.com/photo-1471943311424-646960669fbc?q=80&w=500', price: '\$15.00', water: 'Low', light: 'Full Sun', humidity: 'Dry', temperature: '15-30°C'),
      'time': 'Wednesdays'
    },
    {
      'plant': Plant(id: 's1', name: 'Aloe Vera', species: 'Aloe', category: 'Succulents', description: 'Healing.', imageUrl: 'https://images.unsplash.com/photo-1596547609652-9cf5d8d76921?q=80&w=500', price: '\$12.00', water: 'Low', light: 'Bright', humidity: 'Low', temperature: '20-35°C'),
      'time': 'Every Friday'
    },
    {
      'plant': Plant(id: 'i2', name: 'Monstera', species: 'Deliciosa', category: 'Indoor', description: 'Tropical.', imageUrl: 'https://images.unsplash.com/photo-1614594975525-e45190c55d0b?q=80&w=500', price: '\$45.00', water: 'Weekly', light: 'Bright', humidity: 'High', temperature: '20-30°C'),
      'time': 'Sundays'
    },
    {
      'plant': Plant(id: 'f1', name: 'Red Rose', species: 'Rosa', category: 'Flowers', description: 'Romantic.', imageUrl: 'https://images.unsplash.com/photo-1496062031456-07b8f162a322?q=80&w=500', price: '\$12.00', water: 'Regular', light: 'Full Sun', humidity: 'Med', temperature: '15-25°C'),
      'time': 'Daily at 6:00 PM'
    },
    {
      'plant': Plant(id: 'o3', name: 'Hydrangea', species: 'Macrophylla', category: 'Outdoor', description: 'Colorful.', imageUrl: 'https://images.unsplash.com/photo-1507052822491-07304561847e?q=80&w=500', price: '\$35.00', water: 'High', light: 'Shade', humidity: 'High', temperature: '15-25°C'),
      'time': 'Every Morning'
    },
    {
      'plant': Plant(id: 's2', name: 'Echeveria', species: 'Rosette', category: 'Succulents', description: 'Cute.', imageUrl: 'https://images.unsplash.com/photo-1509423350716-97f9360b4e8e?q=80&w=500', price: '\$8.00', water: 'Low', light: 'Bright', humidity: 'Low', temperature: '15-30°C'),
      'time': 'Weekly'
    },
    {
      'plant': Plant(id: 'f2', name: 'Sunflower', species: 'Helianthus', category: 'Flowers', description: 'Bright.', imageUrl: 'https://images.unsplash.com/photo-1470509037663-253afd7f0f51?q=80&w=500', price: '\$5.00', water: 'High', light: 'Full Sun', humidity: 'Low', temperature: '20-30°C'),
      'time': 'Daily'
    },
    {
      'plant': Plant(id: 'o4', name: 'Boxwood', species: 'Buxus', category: 'Outdoor', description: 'Hedging.', imageUrl: 'https://images.unsplash.com/photo-1584483766114-2cea6facdf57?q=80&w=500', price: '\$28.00', water: 'Medium', light: 'Full Sun', humidity: 'Medium', temperature: '10-30°C'),
      'time': 'Bi-weekly'
    }
  ];

  List<Plant> get cart => _cart;
  List<Plant> get favorites => _favorites;
  List<Map<String, dynamic>> get reminders => _reminders;

  void addReminder(Plant plant, String time) {
    _reminders.add({'plant': plant, 'time': time});
    notifyListeners();
  }

  void removeReminder(int index) {
    _reminders.removeAt(index);
    notifyListeners();
  }

  void addToCart(Plant plant) {
    _cart.add(plant);
    notifyListeners();
  }

  void removeFromCart(Plant plant) {
    _cart.remove(plant);
    notifyListeners();
  }

  void toggleFavorite(Plant plant) {
    if (_favorites.contains(plant)) {
      _favorites.remove(plant);
    } else {
      _favorites.add(plant);
    }
    notifyListeners();
  }

  bool isFavorite(Plant plant) {
    return _favorites.contains(plant);
  }

  double get totalCartPrice {
    double total = 0;
    for (var plant in _cart) {
      total += double.tryParse(plant.price.replaceAll('\$', '')) ?? 0;
    }
    return total;
  }
}
