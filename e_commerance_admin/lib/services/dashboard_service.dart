import 'package:supabase_flutter/supabase_flutter.dart';

class DashboardService{

  static final _supabase =
      Supabase.instance.client;


  static Future<int> getProductsCount() async{

    final data =
    await _supabase
        .from('products')
        .select('id');

    return data.length;

  }


  static Future<int> getCategoriesCount() async{

    final data =
    await _supabase
        .from('categories')
        .select('id');

    return data.length;

  }

}