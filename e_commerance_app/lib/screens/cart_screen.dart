import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/loading_widget.dart';
import '../services/card_service.dart';
import 'checkout_screen.dart';


class CartScreen extends StatefulWidget {

  const CartScreen({super.key});


  @override
  State<CartScreen> createState() => _CartScreenState();

}



class _CartScreenState extends State<CartScreen> {


  List<Map<String,dynamic>> cartItems = [];

  bool loading = true;



  final String userId = "CURRENT_USER_ID";



  @override
  void initState(){

    super.initState();

    loadCart();

  }



  Future<void> loadCart() async {


    final data =
    await CartService.getCartItems(userId);



    setState((){

      cartItems = data;

      loading = false;

    });


  }





  double getTotal(){


    double total = 0;


    for(var item in cartItems){


      final product = item['products'];


      if(product != null){

        total +=
            (product['price'] ?? 0) *
                (item['quantity'] ?? 1);

      }


    }


    return total;


  }





  Future<void> removeItem(int id) async{


    await CartService.removeItem(id);


    loadCart();


  }




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
          "My Cart",
        ),

        centerTitle:true,

      ),



      body:loading

          ? const LoadingWidget()



          :cartItems.isEmpty


          ? const Center(

        child:Text(
          "Cart is Empty",
        ),

      )



          :Column(


        children:[


          Expanded(


            child:ListView.builder(


              padding:
              const EdgeInsets.all(15),


              itemCount:
              cartItems.length,



              itemBuilder:(context,index){


                final item =
                cartItems[index];


                final product =
                item['products'];



                return Card(


                  child:ListTile(


                    leading:SizedBox(


                      width:60,


                      child:Image.network(

                        product['image'],

                        fit:BoxFit.cover,

                      ),

                    ),



                    title:Text(

                      product['name'],

                    ),



                    subtitle:Text(

                      "Quantity: ${item['quantity']}",

                    ),



                    trailing:IconButton(


                      icon:
                      const Icon(
                        Icons.delete,
                      ),



                      onPressed:(){

                        removeItem(

                          item['id'],

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
            const EdgeInsets.all(20),



            child:Column(


              children:[



                Text(

                  "Total: \$${getTotal().toStringAsFixed(2)}",


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


                  height:55,



                  child:ElevatedButton(


                    onPressed:(){


                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder:(_)=>

                              CheckoutScreen(

                                total:getTotal(),

                              ),

                        ),

                      );


                    },


                    child:
                    const Text(
                      "Checkout",
                    ),


                  ),


                )



              ],


            ),


          )


        ],


      ),


    );


  }


}