import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/loading_widget.dart';
import '../services/order_service.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState()=>_OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>{

  List<Map<String,dynamic>> orders=[];
  bool loading=true;


  @override
  void initState(){
    super.initState();
    loadOrders();
  }


  Future<void> loadOrders() async{

    final data = await OrderService.getOrders(
      "current_user_id",
    );


    setState((){

      orders=data;
      loading=false;

    });

  }



  Future<void> cancelOrder(int id) async{

    await OrderService.cancelOrder(id);

    loadOrders();

  }



  Future<void> deleteOrder(int id) async{

    await OrderService.deleteOrder(id);

    loadOrders();

  }



  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor:AppColors.background,


      appBar:AppBar(

        backgroundColor:AppColors.primary,

        title:const Text(
          "My Orders",
        ),

        centerTitle:true,

      ),



      body:loading

          ? const LoadingWidget()


          :orders.isEmpty

          ? const Center(

        child:Text(
          "No Orders Found",
        ),

      )


          :ListView.builder(

        padding:const EdgeInsets.all(15),

        itemCount:orders.length,


        itemBuilder:(context,index){


          final order=orders[index];


          return Card(

            child:Padding(

              padding:const EdgeInsets.all(15),

              child:Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children:[


                  Text(

                    "Order ID: ${order['id']}",

                    style:const TextStyle(

                      fontWeight:FontWeight.bold,

                    ),

                  ),



                  const SizedBox(height:8),



                  Text(

                    "Amount: \$${order['total_amount']}",

                  ),



                  const SizedBox(height:8),



                  Text(

                    "Status: ${order['status']}",

                  ),



                  const SizedBox(height:10),



                  Row(

                    mainAxisAlignment:
                    MainAxisAlignment.end,


                    children:[


                      TextButton(

                        onPressed:(){

                          cancelOrder(
                            order['id'],
                          );

                        },

                        child:const Text(
                          "Cancel",
                        ),

                      ),



                      TextButton(

                        onPressed:(){

                          deleteOrder(
                            order['id'],
                          );

                        },

                        child:const Text(
                          "Delete",
                        ),

                      ),


                    ],

                  )


                ],

              ),

            ),

          );


        },

      ),

    );

  }

}