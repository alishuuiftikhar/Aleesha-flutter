import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';


class CategoryProvider extends ChangeNotifier{


  List<CategoryModel> _categories=[];

  bool _loading=false;



  List<CategoryModel> get categories =>
      _categories;



  bool get loading =>
      _loading;



  Future<void> loadCategories() async{


    _loading=true;

    notifyListeners();



    try{


      _categories =
      await CategoryService.getCategories();



    }catch(e){


      _categories=[];


    }



    _loading=false;

    notifyListeners();


  }



  void clearCategories(){


    _categories=[];

    notifyListeners();


  }


}