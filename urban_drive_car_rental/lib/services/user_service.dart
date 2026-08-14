import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService extends ChangeNotifier {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  String _name = 'Alex Johnson';
  String _email = 'alex.johnson@example.com';
  String _phone = '+92 300 1234567';

  String get name => _name;
  String get email => _email;
  String get phone => _phone;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('user_name') ?? _name;
    _email = prefs.getString('user_email') ?? _email;
    _phone = prefs.getString('user_phone') ?? _phone;
    notifyListeners();
  }

  Future<void> updateProfile(String name, String email, String phone) async {
    final prefs = await SharedPreferences.getInstance();
    _name = name;
    _email = email;
    _phone = phone;
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    await prefs.setString('user_phone', phone);
    notifyListeners();
  }
}
