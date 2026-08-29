import 'package:supabase_flutter/supabase_flutter.dart';

class ProductService{
  ProductService._();
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<List<Map<String,dynamic>>> getProducts() async{
    try{
      final response = await _supabase
          .from('products')
          .select()
          .order('id', ascending: true);
      
      return List<Map<String,dynamic>>.from(response);
    } catch(e){
      print("DATABASE ERROR: $e");
      return [];
    }
  }

  static Future<List<Map<String,dynamic>>> getCategories() async{
    try{
      final response = await _supabase
          .from('categories')
          .select()
          .order('id', ascending: true);
      return List<Map<String,dynamic>>.from(response);
    } catch(e){
      return [];
    }
  }
}
