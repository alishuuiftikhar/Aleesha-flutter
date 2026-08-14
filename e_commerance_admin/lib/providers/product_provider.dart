import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier{

  List<ProductModel> products=[];

  bool loading=false;

  Future<void> loadProducts() async{

    loading=true;
    notifyListeners();

    products=
    await ProductService.getProducts();

    loading=false;
    notifyListeners();

  }

  Future<void> addProduct({

    required String name,
    required double price,
    required String description,
    required int categoryId,

  }) async{

    await ProductService.addProduct(

      name:name,
      price:price,
      description:description,
      categoryId:categoryId,

    );

    await loadProducts();

  }

  Future<void> deleteProduct(
      int id) async{

    await ProductService.deleteProduct(id);

    await loadProducts();

  }

}