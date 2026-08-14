import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';

class ProductService{

  ProductService._();

  static final SupabaseClient _supabase =
      Supabase.instance.client;


  static Future<List<ProductModel>> getProducts() async{

    final response =
    await _supabase
        .from('products')
        .select()
        .order('id');


    return (response as List)
        .map(
          (e)=>ProductModel.fromJson(
        e as Map<String,dynamic>,
      ),
    )
        .toList();

  }



  static Future<void> addProduct({

    required String name,

    required double price,

    required String description,

    required int categoryId,

  }) async{


    await _supabase
        .from('products')
        .insert({

      'name':name,

      'price':price,

      'description':description,

      'category_id':categoryId,

    });


  }




  static Future<void> updateProduct({

    required int id,

    required String name,

    required double price,

    required String description,

    required int categoryId,

  }) async{


    await _supabase
        .from('products')
        .update({

      'name':name,

      'price':price,

      'description':description,

      'category_id':categoryId,

    })
        .eq(
      'id',
      id,
    );


  }




  static Future<void> deleteProduct(int id) async{


    await _supabase
        .from('products')
        .delete()
        .eq(
      'id',
      id,
    );


  }


}