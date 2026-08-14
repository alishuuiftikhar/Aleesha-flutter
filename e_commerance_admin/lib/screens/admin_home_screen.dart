import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/dashboard_service.dart';

import 'add_product_screen.dart';
import 'product_list_screen.dart';
import 'add_category_screen.dart';
import 'category_list_screen.dart';
import 'order_list_screen.dart';
import 'admin_profile_screen.dart';
import 'admin_login_screen.dart';



class AdminHomeScreen extends StatefulWidget{

  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState()=>_AdminHomeScreenState();

}



class _AdminHomeScreenState extends State<AdminHomeScreen>{


  int products=0;
  int categories=0;



  @override
  void initState(){

    super.initState();

    loadCounts();

  }



  Future<void> loadCounts() async{

    final p =
    await DashboardService.getProductsCount();


    final c =
    await DashboardService.getCategoriesCount();



    setState((){

      products=p;

      categories=c;

    });

  }



  @override
  Widget build(BuildContext context){

    return Scaffold(


      appBar:AppBar(

        title:
        const Text("Admin Panel"),

        centerTitle:true,


        actions:[


          IconButton(

            icon:
            const Icon(Icons.logout),


            onPressed:()async{


              await Supabase.instance.client.auth.signOut();


              if(!context.mounted)return;


              Navigator.pushReplacement(

                context,

                MaterialPageRoute(

                  builder:(_)=>
                  const AdminLoginScreen(),

                ),

              );


            },

          ),

        ],


      ),




      body:Padding(

        padding:
        const EdgeInsets.all(15),


        child:ListView(


          children:[



            Row(

              children:[


                countCard(

                  "Products",

                  products.toString(),

                  Icons.shopping_bag,

                ),



                const SizedBox(width:15),



                countCard(

                  "Categories",

                  categories.toString(),

                  Icons.category,

                ),


              ],


            ),



            const SizedBox(height:20),




            GridView(

              shrinkWrap:true,

              physics:
              const NeverScrollableScrollPhysics(),



              gridDelegate:

              const SliverGridDelegateWithFixedCrossAxisCount(

                crossAxisCount:2,

                crossAxisSpacing:12,

                mainAxisSpacing:12,

              ),



              children:[



                adminCard(

                  context,

                  "Add Product",

                  Icons.add_box,

                  const AddProductScreen(),

                ),



                adminCard(

                  context,

                  "Products",

                  Icons.shopping_bag,

                  const ProductListScreen(),

                ),



                adminCard(

                  context,

                  "Add Category",

                  Icons.category,

                  const AddCategoryScreen(),

                ),



                adminCard(

                  context,

                  "Categories",

                  Icons.list,

                  const CategoryListScreen(),

                ),



                adminCard(

                  context,

                  "Orders",

                  Icons.receipt_long,

                  const OrderListScreen(),

                ),



                adminCard(

                  context,

                  "Profile",

                  Icons.person,

                  const AdminProfileScreen(),

                ),



              ],


            ),


          ],


        ),


      ),


    );

  }




  Widget countCard(

      String title,

      String value,

      IconData icon){

    return Expanded(

      child:Card(

        child:Padding(

          padding:
          const EdgeInsets.all(15),


          child:Column(

            children:[


              Icon(
                icon,
                size:35,
              ),


              Text(

                value,

                style:
                const TextStyle(

                  fontSize:25,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),



              Text(title),


            ],

          ),

        ),

      ),

    );

  }




  Widget adminCard(

      BuildContext context,

      String title,

      IconData icon,

      Widget screen){


    return InkWell(

      onTap:(){

        Navigator.push(

          context,

          MaterialPageRoute(

            builder:(_)=>screen,

          ),

        );

      },


      child:Card(

        elevation:4,


        child:Column(

          mainAxisAlignment:
          MainAxisAlignment.center,


          children:[


            Icon(

              icon,

              size:45,

              color:Colors.deepPurple,

            ),



            const SizedBox(height:10),



            Text(

              title,

              textAlign:
              TextAlign.center,


              style:
              const TextStyle(

                fontWeight:
                FontWeight.bold,

              ),

            ),


          ],

        ),

      ),

    );

  }


}