import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_model.dart';

class CategoryService{

  CategoryService._();

  static final SupabaseClient _supabase=Supabase.instance.client;


  static Future<List<CategoryModel>> getCategories() async{

    try{

      final response=await _supabase
          .from('categories')
          .select()
          .order('id',ascending:true);


      return (response as List)
          .map((item)=>CategoryModel.fromJson(
        item as Map<String,dynamic>,
      ))
          .toList();


    }catch(e){

      throw Exception(
        "Category Load Error: $e",
      );

    }

  }



  static Future<void> addCategory({
    required String name,
    required String image,
  }) async{

    await _supabase
        .from('categories')
        .insert({
      'name':name,
      'image':image,
    });

  }



  static Future<void> deleteCategory(int id) async{

    await _supabase
        .from('categories')
        .delete()
        .eq('id',id);

  }

}