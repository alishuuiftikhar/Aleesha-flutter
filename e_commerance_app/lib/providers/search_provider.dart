import 'package:flutter/material.dart';
import '../services/search_service.dart';


class SearchProvider extends ChangeNotifier{


  List<Map<String,dynamic>> _results=[];


  bool _loading=false;


  String _query="";



  List<Map<String,dynamic>> get results =>
      _results;



  bool get loading =>
      _loading;



  String get query =>
      _query;



  Future<void> searchProducts(
      String value
      ) async{


    _query=value;


    if(value.trim().isEmpty){


      _results=[];

      notifyListeners();

      return;

    }



    _loading=true;

    notifyListeners();



    try{


      _results =
      await SearchService.searchProducts(
        value,
      );



    }catch(e){


      _results=[];


    }



    _loading=false;

    notifyListeners();


  }




  void clearSearch(){


    _query="";

    _results=[];


    notifyListeners();


  }


}