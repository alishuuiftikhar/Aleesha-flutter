import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';

class CategoryProvider extends ChangeNotifier{

  List<CategoryModel> categories=[];

  bool loading=false;

  Future<void> loadCategories() async{

    loading=true;
    notifyListeners();

    categories=
    await CategoryService.getCategories();

    loading=false;
    notifyListeners();

  }

  Future<void> addCategory(
      String name) async{

    await CategoryService.addCategory(name);

    await loadCategories();

  }

  Future<void> deleteCategory(
      int id) async{

    await CategoryService.deleteCategory(id);

    await loadCategories();

  }

}