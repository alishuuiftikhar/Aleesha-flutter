import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../services/order_service.dart';
import '../theme/app_colors.dart';


class OrderListScreen extends StatefulWidget{

  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState()=>_OrderListScreenState();

}


class _OrderListScreenState extends State<OrderListScreen>{

  List<OrderModel> orders=[];
  bool loading=true;


  @override
  void initState(){

    super.initState();

    loadOrders();

  }


  Future<void> loadOrders() async{

    final data =
    await OrderService.getOrders();

    setState((){

      orders=data;
      loading=false;

    });

  }



  Future<void> changeStatus(
      int id,
      String status) async{

    await OrderService.updateStatus(
      id,
      status,
    );

    loadOrders();

  }



  Future<void> deleteOrder(int id) async{

    await OrderService.deleteOrder(id);

    loadOrders();

  }



  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor:
      AppColors.background,


      appBar:AppBar(

        title:
        const Text("Orders"),

      ),


      body:loading

          ?const Center(
        child:CircularProgressIndicator(),
      )


          :orders.isEmpty

          ?const Center(
        child:Text("No Orders Found"),
      )


          :ListView.builder(

        padding:
        const EdgeInsets.all(15),

        itemCount:
        orders.length,


        itemBuilder:(context,index){

          final order=orders[index];


          return Card(

            child:ListTile(

              title:
              Text(
                "Order #${order.id}",
              ),


              subtitle:
              Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children:[

                  Text(
                    "Total: \$${order.totalPrice}",
                  ),

                  Text(
                    "Status: ${order.status}",
                  ),

                  DropdownButton<String>(

                    value:
                    order.status,


                    items:
                    [
                      "Pending",
                      "Confirmed",
                      "Delivered",
                    ]
                        .map(
                          (e)=>DropdownMenuItem(
                        value:e,
                        child:Text(e),
                      ),
                    )
                        .toList(),


                    onChanged:(value){

                      if(value!=null){

                        changeStatus(
                          order.id!,
                          value,
                        );

                      }

                    },

                  ),

                ],

              ),


              trailing:
              IconButton(

                icon:
                const Icon(
                  Icons.delete,
                  color:Colors.red,
                ),


                onPressed:(){

                  deleteOrder(
                    order.id!,
                  );

                },

              ),

            ),

          );

        },

      ),

    );

  }

}