import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier{

  final SupabaseClient _supabase =
      Supabase.instance.client;


  User? _user;


  User? get user => _user;



  bool get isLoggedIn =>
      _user != null;



  AuthProvider(){

    checkUser();

  }



  void checkUser(){

    _user =
        _supabase.auth.currentUser;

    notifyListeners();

  }



  Future<void> logout() async{

    await _supabase.auth.signOut();

    _user=null;

    notifyListeners();

  }



  void updateUser(User user){

    _user=user;

    notifyListeners();

  }


}