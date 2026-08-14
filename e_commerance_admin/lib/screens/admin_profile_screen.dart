import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'admin_login_screen.dart';


class AdminProfileScreen extends StatelessWidget{

  const AdminProfileScreen({super.key});


  @override
  Widget build(BuildContext context){

    final user =
        Supabase.instance.client.auth.currentUser;


    return Scaffold(

      appBar:AppBar(
        title:const Text("Admin Profile"),
      ),


      body:Padding(

        padding:
        const EdgeInsets.all(20),

        child:Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children:[


            const Icon(

              Icons.admin_panel_settings,

              size:90,

              color:Colors.deepPurple,

            ),



            const SizedBox(height:20),



            const Text(

              "Email",

              style:TextStyle(

                fontWeight:
                FontWeight.bold,

                fontSize:18,

              ),

            ),



            Text(
              user?.email ?? "No Email",
            ),



            const SizedBox(height:20),



            const Text(

              "User ID",

              style:TextStyle(

                fontWeight:
                FontWeight.bold,

                fontSize:18,

              ),

            ),



            Text(
              user?.id ?? "",
            ),



            const Spacer(),



            SizedBox(

              width:
              double.infinity,

              height:
              55,


              child:ElevatedButton(


                onPressed:()async{


                  await Supabase.instance.client
                      .auth
                      .signOut();


                  if(!context.mounted)return;


                  Navigator.pushReplacement(

                    context,

                    MaterialPageRoute(

                      builder:(_)=>
                      const AdminLoginScreen(),

                    ),

                  );


                },


                child:
                const Text("Logout"),

              ),

            ),


          ],

        ),

      ),

    );

  }

}