import 'package:flutter/material.dart';
import '../theme/app_colors.dart';


class AboutScreen extends StatelessWidget{


  const AboutScreen({super.key});



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
          "About App",
        ),

        centerTitle:true,

      ),



      body:Center(


        child:Padding(

          padding:
          const EdgeInsets.all(20),



          child:Column(


            mainAxisAlignment:
            MainAxisAlignment.center,



            children:[


              const Icon(

                Icons.shopping_bag,

                size:90,

                color:
                AppColors.primary,

              ),



              const SizedBox(height:20),



              const Text(

                "E-Commerce App",

                style:
                TextStyle(

                  fontSize:26,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),



              const SizedBox(height:10),



              const Text(

                "Version 1.0.0",

                style:
                TextStyle(

                  fontSize:16,

                  color:
                  AppColors.grey,

                ),

              ),



              const SizedBox(height:20),



              const Text(

                "A modern shopping application "
                    "built with Flutter and Supabase. "
                    "Users can browse products, "
                    "manage cart, wishlist and orders.",


                textAlign:
                TextAlign.center,


                style:
                TextStyle(

                  fontSize:16,

                ),

              ),



            ],


          ),

        ),


      ),


    );


  }


}