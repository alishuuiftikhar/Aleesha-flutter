import 'package:flutter/material.dart';
import '../services/wishlist_service.dart';


class WishlistProvider extends ChangeNotifier {


  List<Map<String, dynamic>> _items = [];

  bool _loading = false;



  List<Map<String, dynamic>> get items => _items;


  bool get loading => _loading;



  int get wishlistCount => _items.length;



  Future<void> loadWishlist(String userId) async {


    _loading = true;

    notifyListeners();



    try {


      _items = await WishlistService.getWishlist(userId);



    } catch (e) {


      _items = [];


    }



    _loading = false;

    notifyListeners();


  }





  Future<void> addWishlist({

    required String userId,

    required int productId,

  }) async {


    await WishlistService.addToWishlist(

      userId: userId,

      productId: productId,

    );


    await loadWishlist(userId);


  }






  Future<void> removeWishlist({

    required String userId,

    required int productId,

  }) async {


    await WishlistService.removeFromWishlist(

      userId: userId,

      productId: productId,

    );


    await loadWishlist(userId);


  }






  bool isFavorite(int productId) {


    return _items.any(

          (item) => item['product_id'] == productId,

    );


  }





  void clearWishlist() {


    _items = [];

    notifyListeners();


  }


}