import 'package:flutter/material.dart';
import '../services/profile_service.dart';


class ProfileProvider extends ChangeNotifier{


  Map<String,dynamic>? _profile;


  bool _loading=false;



  Map<String,dynamic>? get profile =>
      _profile;



  bool get loading =>
      _loading;



  Future<void> loadProfile(
      String userId
      ) async{


    _loading=true;

    notifyListeners();



    try{


      _profile =
      await ProfileService.getProfile(
        userId,
      );



    }catch(e){


      _profile=null;


    }



    _loading=false;

    notifyListeners();


  }




  Future<void> updateProfile({

    required String userId,

    required String fullName,

    required String phone,

    required String address,

    String? profileImage,

  }) async{


    await ProfileService.updateProfile(

      userId:userId,

      fullName:fullName,

      phone:phone,

      address:address,

      profileImage:profileImage,

    );


    await loadProfile(userId);


  }




  void clearProfile(){


    _profile=null;

    notifyListeners();


  }


}