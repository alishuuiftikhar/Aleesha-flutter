import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

import 'home_screen.dart';
import 'cart_screen.dart';
import 'order_screen.dart';
import 'profile_screen.dart';


class MainScreen extends StatefulWidget{

  const MainScreen({super.key});


  @override
  State<MainScreen> createState()=>_MainScreenState();

}


class _MainScreenState extends State<MainScreen>{


  int currentIndex=0;



  final List<Widget> screens=[

    const HomeScreen(),

    const CartScreen(),

    const OrdersScreen(),

    const ProfileScreen(),

  ];



  @override
  Widget build(BuildContext context){

    return Scaffold(


      body:screens[currentIndex],



      bottomNavigationBar:BottomNavigationBar(


        currentIndex:currentIndex,


        selectedItemColor:AppColors.primary,


        unselectedItemColor:AppColors.grey,


        type:BottomNavigationBarType.fixed,



        onTap:(index){


          setState((){


            currentIndex=index;


          });


        },


        items:[


          const BottomNavigationBarItem(

            icon:Icon(Icons.home),

            label:"Home",

          ),



          const BottomNavigationBarItem(

            icon:Icon(Icons.shopping_cart),

            label:"Cart",

          ),



          const BottomNavigationBarItem(

            icon:Icon(Icons.receipt_long),

            label:"Orders",

          ),



          const BottomNavigationBarItem(

            icon:Icon(Icons.person),

            label:"Profile",

          ),



        ],

      ),

    );

  }

}