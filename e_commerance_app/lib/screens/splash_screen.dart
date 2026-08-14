import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'login_screen.dart';


class SplashScreen extends StatefulWidget{

  const SplashScreen({super.key});


  @override
  State<SplashScreen> createState()=>_SplashScreenState();

}


class _SplashScreenState extends State<SplashScreen>{


  @override
  void initState(){

    super.initState();


    Timer(
      const Duration(seconds:3),
          (){

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:(_)=>const LoginScreen(),
          ),
        );

      },
    );

  }



  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor:AppColors.primary,


      body:Center(

        child:Column(

          mainAxisAlignment:
          MainAxisAlignment.center,


          children:[


            const Icon(

              Icons.shopping_bag_rounded,

              size:100,

              color:Colors.white,

            ),


            const SizedBox(height:20),


            const Text(

              "E-Commerce App",

              style:TextStyle(

                color:Colors.white,

                fontSize:30,

                fontWeight:FontWeight.bold,

              ),

            ),


            const SizedBox(height:10),


            const Text(

              "Shop Smart, Shop Easy",

              style:TextStyle(

                color:Colors.white70,

                fontSize:16,

              ),

            ),


            const SizedBox(height:40),


            const CircularProgressIndicator(

              color:Colors.white,

            ),


          ],

        ),

      ),

    );

  }

}