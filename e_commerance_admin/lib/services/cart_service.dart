import 'package:supabase_flutter/supabase_flutter.dart';


class CartService{


  static final _supabase =
      Supabase.instance.client;



  static Future<void> addToCart({

    required String userId,

    required int productId,

    required int quantity,

  }) async{


    await _supabase
        .from('cart')
        .insert({

      'user_id':userId,

      'product_id':productId,

      'quantity':quantity,

    });


  }



  static Future<void> deleteCartItem(
      int id) async{


    await _supabase
        .from('cart')
        .delete()
        .eq('id',id);


  }



  static Future<List<dynamic>> getCart(
      String userId) async{


    final data =
    await _supabase
        .from('cart')
        .select('''
          id,
          quantity,
          products(
            name,
            price,
            description
          )
        ''')
        .eq('user_id',userId);


    return data;

  }


}