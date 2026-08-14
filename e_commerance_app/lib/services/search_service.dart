import 'package:supabase_flutter/supabase_flutter.dart';


class SearchService {


  SearchService._();


  static final SupabaseClient _supabase =
      Supabase.instance.client;



  // Search Products

  static Future<List<Map<String,dynamic>>> searchProducts(
      String keyword
      ) async {


    final response =
    await _supabase
        .from('products')
        .select()
        .ilike(
      'name',
      '%$keyword%',
    );


    return List<Map<String,dynamic>>.from(response);

  }




  // Products By CategoryppppN

  static Future<List<Map<String,dynamic>>> filterByCategory(
      int categoryId
      ) async {


    final response =
    await _supabase
        .from('products')
        .select()
        .eq(
      'category_id',
      categoryId,
    );


    return List<Map<String,dynamic>>.from(response);

  }



}