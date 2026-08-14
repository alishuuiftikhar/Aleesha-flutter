import 'package:flutter/material.dart';
import '../services/order_service.dart';


class OrderProvider extends ChangeNotifier{


  List<Map<String,dynamic>> _orders=[];

  bool _loading=false;



  List<Map<String,dynamic>> get orders =>
      _orders;



  bool get loading =>
      _loading;



  Future<void> loadOrders(String userId) async{


    _loading=true;

    notifyListeners();



    try{


      _orders =
      await OrderService.getOrders(userId);



    }catch(e){


      _orders=[];


    }



    _loading=false;

    notifyListeners();


  }




  Future<void> createOrder({

    required String userId,

    required double totalAmount,

    required String status,

  }) async{


    await OrderService.createOrder(

      userId:userId,

      totalAmount:totalAmount,

      status:status,

    );


    await loadOrders(userId);


  }




  Future<void> cancelOrder({

    required int orderId,

    required String userId,

  }) async{


    await OrderService.cancelOrder(
      orderId,
    );


    await loadOrders(userId);


  }




  Future<void> deleteOrder({

    required int orderId,

    required String userId,

  }) async{


    await OrderService.deleteOrder(
      orderId,
    );


    await loadOrders(userId);


  }



  void clearOrders(){


    _orders=[];

    notifyListeners();


  }


}