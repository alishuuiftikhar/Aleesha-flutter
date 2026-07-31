import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/auth_service.dart';
import  'admin_login_screen.dart';
import 'add_category_screen.dart';
import 'category_list_screen.dart';
import 'add_product_screen.dart';
import 'product_list_screen.dart';
import 'order_list_screen.dart';

class DashboardScreen extends StatelessWidget{

  const DashboardScreen({super.key});

  Widget card(
      BuildContext context,
      IconData icon,
      String title,
      Widget page,
      ){

    return InkWell(

      onTap:(){

        Navigator.push(
          context,
          MaterialPageRoute(
            builder:(_)=>page,
          ),
        );

      },

      child:Card(

        child:Column(

          mainAxisAlignment:MainAxisAlignment.center,

          children:[

            Icon(
              icon,
              size:40,
              color:AppColors.primary,
            ),

            const SizedBox(height:10),

            Text(
              title,
              textAlign:TextAlign.center,
            ),

          ],

        ),

      ),

    );

  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor:AppColors.background,

      appBar:AppBar(

        title:const Text("Admin Dashboard"),

        actions:[

          IconButton(

            onPressed:() async{

              await AuthService.logout();

              if(context.mounted){

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder:(_)=>const AdminLoginScreen(),
                  ),
                      (route)=>false,
                );

              }

            },

            icon:const Icon(Icons.logout),

          ),

        ],

      ),

      body:Padding(

        padding:const EdgeInsets.all(15),

        child:GridView.count(

          crossAxisCount:2,
          crossAxisSpacing:15,
          mainAxisSpacing:15,

          children:[

            card(
              context,
              Icons.category,
              "Add Category",
              const AddCategoryScreen(),
            ),

            card(
              context,
              Icons.list,
              "Categories",
              const CategoryListScreen(),
            ),

            card(
              context,
              Icons.shopping_bag,
              "Add Product",
              const AddProductScreen(),
            ),

            card(
              context,
              Icons.inventory,
              "Products",
              const ProductListScreen(),
            ),

            card(
              context,
              Icons.receipt_long,
              "Orders",
              const OrderListScreen(),
            ),

          ],

        ),

      ),

    );

  }

}