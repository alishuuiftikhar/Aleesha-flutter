import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/order_model.dart';


class OrderService{

  static final _supabase =
      Supabase.instance.client;



  static Future<List<OrderModel>> getOrders() async{

    final data =
    await _supabase
        .from('shop_orders')
        .select()
        .order('id');


    return (data as List)
        .map(
          (e)=>OrderModel.fromJson(e),
    )
        .toList();

  }



  static Future<void> addOrder({

    required String userId,

    required double totalPrice,

  }) async{


    await _supabase
        .from('shop_orders')
        .insert({

      'user_id':userId,

      'total_price':totalPrice,

      'status':'Pending',

    });


  }



  static Future<void> updateStatus(

      int id,

      String status,

      ) async{


    await _supabase
        .from('shop_orders')
        .update({

      'status':status,

    })
        .eq('id',id);


  }



  static Future<void> deleteOrder(

      int id,

      ) async{


    await _supabase
        .from('shop_orders')
        .delete()
        .eq('id',id);


  }


}