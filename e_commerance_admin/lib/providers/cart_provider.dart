import 'package:flutter/material.dart';

import '../services/cart_service.dart';


class CartProvider extends ChangeNotifier{


  final List<Map<String,dynamic>> _cart=[];


  List<Map<String,dynamic>> get cart=>_cart;



  double get totalPrice{

    double total=0;


    for(var item in _cart){

      total +=
          (item['price'] ?? 0) *
              (item['quantity'] ?? 1);

    }


    return total;

  }



  Future<void> loadCart(String userId) async{


    final data =
    await CartService.getCart(userId);



    _cart.clear();



    for(var item in data){

      _cart.add({

        'id':item['id'],

        'name':
        item['products']['name'],

        'price':
        item['products']['price'],

        'quantity':
        item['quantity'],

      });

    }


    notifyListeners();

  }




  Future<void> addItem({

    required String userId,

    required int productId,

    required int quantity,

  }) async{


    await CartService.addToCart(

      userId:userId,

      productId:productId,

      quantity:quantity,

    );


    await loadCart(userId);


  }




  Future<void> removeItem(

      int id,

      String userId,

      ) async{


    await CartService.deleteCartItem(id);


    await loadCart(userId);


  }




  void clearCart(){

    _cart.clear();

    notifyListeners();

  }


}