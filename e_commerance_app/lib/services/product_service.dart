import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService{

  ProductService._();

  static final SupabaseClient _supabase=Supabase.instance.client;


  static Future<List<Map<String,dynamic>>> getProducts() async{

    try{

      final response=await _supabase
          .from('products')
          .select()
          .order('id',ascending:true);

      return List<Map<String,dynamic>>.from(response);

    }catch(e){

      throw Exception(
        "Product Load Error: $e",
      );

    }

  }



  static Future<List<Map<String,dynamic>>> getCategories() async{

    try{

      final response=await _supabase
          .from('categories')
          .select()
          .order('id',ascending:true);

      return List<Map<String,dynamic>>.from(response);

    }catch(e){

      throw Exception(
        "Category Load Error: $e",
      );

    }

  }



  static Future<List<Map<String,dynamic>>> getProductsByCategory(
      int categoryId) async{

    final response=await _supabase
        .from('products')
        .select()
        .eq('category_id',categoryId);

    return List<Map<String,dynamic>>.from(response);

  }



  static Future<Map<String,dynamic>?> getProduct(int id) async{

    final response=await _supabase
        .from('products')
        .select()
        .eq('id',id)
        .maybeSingle();

    return response;

  }



  static Future<List<Map<String,dynamic>>> searchProduct(
      String keyword) async{

    final response=await _supabase
        .from('products')
        .select()
        .ilike('name','%$keyword%');

    return List<Map<String,dynamic>>.from(response);

  }

}