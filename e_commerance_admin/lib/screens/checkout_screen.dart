import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../providers/cart_provider.dart';
import '../services/order_service.dart';
import '../theme/app_colors.dart';
import 'package:provider/provider.dart';


class CheckoutScreen extends StatelessWidget{

  const CheckoutScreen({super.key});


  @override
  Widget build(BuildContext context){


    final cartProvider =
    Provider.of<CartProvider>(context);



    final user =
        Supabase.instance.client.auth.currentUser;



    return Scaffold(

      backgroundColor:
      AppColors.background,


      appBar:AppBar(

        title:
        const Text("Checkout"),

      ),


      body:Padding(

        padding:
        const EdgeInsets.all(20),


        child:Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,


          children:[


            Text(

              "Total Amount",

              style:
              const TextStyle(

                fontSize:20,

                fontWeight:
                FontWeight.bold,

              ),

            ),



            const SizedBox(height:10),



            Text(

              "\$${cartProvider.totalPrice}",

              style:

              TextStyle(

                fontSize:26,

                color:
                AppColors.primary,

                fontWeight:
                FontWeight.bold,

              ),

            ),



            const Spacer(),



            SizedBox(

              width:
              double.infinity,


              height:
              55,


              child:ElevatedButton(


                onPressed:() async{


                  if(user==null)return;



                  await OrderService.addOrder(

                    userId:
                    user.id,


                    totalPrice:
                    cartProvider.totalPrice,

                  );



                  cartProvider.clearCart();



                  if(!context.mounted)return;



                  ScaffoldMessenger.of(context)
                      .showSnackBar(

                    const SnackBar(

                      content:
                      Text(
                        "Order Placed Successfully",
                      ),

                    ),

                  );


                  Navigator.pop(context);


                },


                child:
                const Text(
                  "Place Order",
                ),


              ),

            ),

          ],

        ),

      ),

    );

  }

}