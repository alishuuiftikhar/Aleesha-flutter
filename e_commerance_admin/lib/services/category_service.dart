import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_model.dart';

class CategoryService{

  CategoryService._();

  static final SupabaseClient _supabase =
      Supabase.instance.client;


  static Future<List<CategoryModel>> getCategories() async{

    final response =
    await _supabase
        .from('categories')
        .select()
        .order('id');


    return (response as List)
        .map(
          (e)=>CategoryModel.fromJson(
        e as Map<String,dynamic>,
      ),
    )
        .toList();

  }



  static Future<void> addCategory(
      String name) async{


    await _supabase
        .from('categories')
        .insert({

      'name':name,

    });


  }




  static Future<void> updateCategory(
      int id,
      String name) async{


    await _supabase
        .from('categories')
        .update({

      'name':name,

    })
        .eq(
      'id',
      id,
    );


  }




  static Future<void> deleteCategory(
      int id) async{


    await _supabase
        .from('categories')
        .delete()
        .eq(
      'id',
      id,
    );


  }


}