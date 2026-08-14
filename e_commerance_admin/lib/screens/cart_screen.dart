import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../providers/cart_provider.dart';
import '../theme/app_colors.dart';
import 'checkout_screen.dart';


class CartScreen extends StatefulWidget{

  const CartScreen({super.key});


  @override
  State<CartScreen> createState()=>_CartScreenState();

}



class _CartScreenState extends State<CartScreen>{


  @override
  void initState(){

    super.initState();


    Future.microtask((){

      final user =
          Supabase.instance.client.auth.currentUser;


      if(user!=null){

        Provider.of<CartProvider>(
          context,
          listen:false,
        ).loadCart(user.id);

      }

    });

  }



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
        const Text("My Cart"),

      ),



      body:cartProvider.cart.isEmpty

          ?const Center(

        child:
        Text("Cart is Empty"),

      )


          :Column(

        children:[


          Expanded(

            child:ListView.builder(

              itemCount:
              cartProvider.cart.length,


              itemBuilder:(context,index){


                final item =
                cartProvider.cart[index];


                return Card(

                  margin:
                  const EdgeInsets.all(10),


                  child:ListTile(

                    title:
                    Text(
                      item['name'],
                    ),


                    subtitle:
                    Text(
                      "\$${item['price']} x ${item['quantity']}",
                    ),


                    trailing:
                    IconButton(

                      icon:
                      const Icon(
                        Icons.delete,
                        color:Colors.red,
                      ),


                      onPressed:(){


                        cartProvider.removeItem(

                          item['id'],

                          user!.id,

                        );


                      },

                    ),

                  ),

                );

              },

            ),

          ),



          Padding(

            padding:
            const EdgeInsets.all(15),


            child:Column(

              children:[


                Text(

                  "Total: \$${cartProvider.totalPrice}",

                  style:
                  const TextStyle(

                    fontSize:20,

                    fontWeight:
                    FontWeight.bold,

                  ),

                ),



                const SizedBox(height:15),



                SizedBox(

                  width:
                  double.infinity,


                  height:
                  55,


                  child:ElevatedButton(

                    onPressed:(){

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder:(_)=>
                          const CheckoutScreen(),

                        ),

                      );

                    },


                    child:
                    const Text(
                      "Checkout",
                    ),

                  ),

                ),

              ],

            ),

          ),


        ],

      ),

    );

  }

}