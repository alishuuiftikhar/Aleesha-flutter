import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../routes/app_routes.dart';
import '../providers/auth_provider.dart';


class SplashScreen extends StatefulWidget{

  const SplashScreen({super.key});


  @override
  State<SplashScreen> createState()=>_SplashScreenState();

}


class _SplashScreenState extends State<SplashScreen>{


  @override
  void initState(){

    super.initState();


    Future.delayed(const Duration(seconds:3), (){
      if (!mounted) return;
      
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      
      if (authProvider.isLoggedIn) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });

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