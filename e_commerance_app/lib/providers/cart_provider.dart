import 'package:flutter/material.dart';
import '../services/card_service.dart';


class CartProvider extends ChangeNotifier {


  List<Map<String, dynamic>> _items = [];

  bool _loading = false;


  List<Map<String, dynamic>> get items => _items;


  bool get loading => _loading;


  int get cartCount => _items.length;



  double get totalAmount {

    double total = 0;


    for (var item in _items) {

      total +=
      ((item['price'] ?? 0) *
          (item['quantity'] ?? 1));

    }


    return total;

  }



  Future<void> loadCart(String userId) async {


    _loading = true;

    notifyListeners();


    try {

      _items =
      await CartService.getCartItems(userId);


    } catch (e) {

      _items = [];

    }


    _loading = false;

    notifyListeners();

  }



  Future<void> addItem({

    required String userId,

    required int productId,

    required int quantity,

  }) async {


    await CartService.addToCart(

      userId: userId,

      productId: productId,

      quantity: quantity,

    );


    await loadCart(userId);

  }



  Future<void> removeItem({

    required String userId,

    required int cartId,

  }) async {


    await CartService.removeItem(cartId);


    await loadCart(userId);

  }



  void clearCart() {

    _items = [];

    notifyListeners();

  }


}