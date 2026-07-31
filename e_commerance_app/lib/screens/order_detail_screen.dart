import 'package:flutter/material.dart';
import '../theme/app_colors.dart';


class OrderDetailScreen extends StatelessWidget{


  final Map<String,dynamic> order;


  const OrderDetailScreen({

    super.key,

    required this.order,

  });



  @override
  Widget build(BuildContext context){


    return Scaffold(

      backgroundColor:
      AppColors.background,


      appBar:AppBar(

        backgroundColor:
        AppColors.primary,

        title:
        const Text(
          "Order Details",
        ),

        centerTitle:true,

      ),



      body:Padding(

        padding:
        const EdgeInsets.all(16),


        child:Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,


          children:[


            Text(

              "Order ID: ${order['id']}",

              style:
              const TextStyle(

                fontSize:18,

                fontWeight:
                FontWeight.bold,

              ),

            ),



            const SizedBox(height:15),



            Text(

              "Status: ${order['status']}",

              style:
              TextStyle(

                fontSize:16,

                color:
                AppColors.primary,

              ),

            ),



            const SizedBox(height:15),



            Text(

              "Total: \$${order['total_amount']}",

              style:
              const TextStyle(

                fontSize:18,

                fontWeight:
                FontWeight.bold,

              ),

            ),



            const SizedBox(height:15),



            Text(

              "Date: ${order['created_at']}",

              style:
              const TextStyle(

                fontSize:16,

              ),

            ),



            const SizedBox(height:25),



            const Text(

              "Items",

              style:
              TextStyle(

                fontSize:20,

                fontWeight:
                FontWeight.bold,

              ),

            ),



            const SizedBox(height:10),



            Expanded(

              child:ListView.builder(

                itemCount:
                order['order_items'] == null
                    ? 0
                    : order['order_items'].length,


                itemBuilder:(context,index){


                  final item =
                  order['order_items'][index];


                  return Card(

                    child:ListTile(

                      title:Text(
                        item['product_name'] ?? "",
                      ),


                      subtitle:Text(

                        "Quantity: ${item['quantity']}",

                      ),


                      trailing:Text(

                        "\$${item['price']}",

                      ),

                    ),

                  );


                },

              ),

            )


          ],

        ),

      ),

    );

  }

}