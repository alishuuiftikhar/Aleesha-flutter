import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _name = 'Aleesha Smith';
  String _email = 'aleesha.smith@example.com';
  String _phone = '+1 234 567 890';
  String _location = 'New York, USA';
  String _profileImage = 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&q=80';

  String get name => _name;
  String get email => _email;
  String get phone => _phone;
  String get location => _location;
  String get profileImage => _profileImage;

  void updateProfile({
    required String name,
    required String email,
    required String phone,
    required String location,
  }) {
    _name = name;
    _email = email;
    _phone = phone;
    _location = location;
    notifyListeners();
  }
}
