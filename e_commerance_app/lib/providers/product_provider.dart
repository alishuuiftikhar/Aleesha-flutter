import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier{

  List<ProductModel> _products=[];

  bool _loading=false;


  List<ProductModel> get products=>_products;

  bool get loading=>_loading;



  Future<void> loadProducts() async{

    _loading=true;
    notifyListeners();


    try{

      final data=await ProductService.getProducts();


      _products=data
          .map((item)=>ProductModel.fromJson(item))
          .toList();


      debugPrint(
        "Products Loaded: ${_products.length}",
      );


    }catch(e){

      debugPrint(
        "Product Error: $e",
      );

      _products=[];

    }


    _loading=false;
    notifyListeners();

  }



  void clearProducts(){

    _products=[];

    notifyListeners();

  }

}