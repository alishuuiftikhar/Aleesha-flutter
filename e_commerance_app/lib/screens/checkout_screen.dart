import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../services/order_service.dart';

class CheckoutScreen extends StatefulWidget {

  final double total;

  const CheckoutScreen({
    super.key,
    required this.total,
  });


  @override
  State<CheckoutScreen> createState()=>_CheckoutScreenState();
}


class _CheckoutScreenState extends State<CheckoutScreen>{

  final nameController=TextEditingController();
  final phoneController=TextEditingController();
  final addressController=TextEditingController();


  String paymentMethod="Cash on Delivery";

  bool loading=false;



  Future<void> placeOrder() async{


    setState(() {
      loading=true;
    });


    try{


      await OrderService.createOrder(

        userId:"current_user_id",

        totalAmount:widget.total,

        status:"Pending",

      );


      if(!mounted)return;


      showDialog(

        context:context,

        builder:(context)=>AlertDialog(

          title:const Text(
            "Order Confirmed",
          ),

          content:const Text(
            "Your order has been placed successfully.",
          ),


          actions:[

            TextButton(

              onPressed:(){

                Navigator.popUntil(
                  context,
                      (route)=>route.isFirst,
                );

              },

              child:const Text(
                "OK",
              ),

            )

          ],

        ),

      );


    }catch(e){


      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content:Text(
            e.toString(),
          ),

        ),

      );

    }


    setState(() {
      loading=false;
    });


  }



  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor:AppColors.background,


      appBar:AppBar(

        backgroundColor:AppColors.primary,

        title:const Text(
          "Checkout",
        ),

        centerTitle:true,

      ),


      body:SingleChildScrollView(

        padding:const EdgeInsets.all(20),


        child:Column(

          children:[


            CustomTextField(

              controller:nameController,

              hintText:"Full Name",

              prefixIcon:Icons.person,

            ),


            const SizedBox(height:15),


            CustomTextField(

              controller:phoneController,

              hintText:"Phone Number",

              prefixIcon:Icons.phone,

              keyboardType:TextInputType.phone,

            ),


            const SizedBox(height:15),


            CustomTextField(

              controller:addressController,

              hintText:"Address",

              prefixIcon:Icons.location_on,

            ),



            const SizedBox(height:20),



            DropdownButtonFormField<String>(

              value:paymentMethod,


              items:[

                "Cash on Delivery",

                "Card Payment",

              ].map((e)=>DropdownMenuItem(

                value:e,

                child:Text(e),

              )).toList(),


              onChanged:(value){

                setState(() {

                  paymentMethod=value!;

                });

              },

            ),



            const SizedBox(height:25),



            Text(

              "Total Amount: \$${widget.total.toStringAsFixed(2)}",

              style:const TextStyle(

                fontSize:20,

                fontWeight:FontWeight.bold,

              ),

            ),



            const SizedBox(height:25),



            CustomButton(

              text:"Place Order",

              isLoading:loading,

              onPressed:placeOrder,

            )


          ],

        ),

      ),

    );

  }

}