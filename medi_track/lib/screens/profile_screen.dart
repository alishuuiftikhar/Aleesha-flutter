import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget{
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context){

    final supabase=Supabase.instance.client;
    final user=supabase.auth.currentUser;

    final name=user?.userMetadata?['full_name']??"Admin";
    final email=user?.email??"No Email";
    const pink=Color(0xFFEC4899);

    return Scaffold(
      backgroundColor:Colors.white,

      appBar:AppBar(
        title:const Text("My Profile"),
        centerTitle:true,
        backgroundColor:pink,
        foregroundColor:Colors.white,
      ),

      body:Center(
        child:SingleChildScrollView(
          padding:const EdgeInsets.all(20),

          child:Card(
            elevation:8,
            shape:RoundedRectangleBorder(
              borderRadius:BorderRadius.circular(25),
            ),

            child:Padding(
              padding:const EdgeInsets.all(25),

              child:Column(
                mainAxisSize:MainAxisSize.min,
                children:[

                  CircleAvatar(
                    radius:60,
                    backgroundColor:pink,
                    child:const Icon(
                      Icons.person,
                      size:65,
                      color:Colors.white,
                    ),
                  ),

                  const SizedBox(height:20),

                  Text(
                    name.toString(),
                    style:const TextStyle(
                      fontSize:25,
                      fontWeight:FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height:8),

                  Text(
                    email,
                    style:const TextStyle(
                      color:Colors.grey,
                      fontSize:16,
                    ),
                  ),

                  const SizedBox(height:25),

                  Container(
                    padding:const EdgeInsets.all(18),
                    decoration:BoxDecoration(
                      color:const Color(0xFFFFF0F6),
                      borderRadius:BorderRadius.circular(18),
                    ),

                    child:const Column(
                      children:[

                        Row(
                          children:[
                            Icon(Icons.local_hospital,color:pink),
                            SizedBox(width:10),
                            Text(
                              "Hospital Management System",
                              style:TextStyle(fontWeight:FontWeight.bold),
                            ),
                          ],
                        ),

                        SizedBox(height:12),

                        Row(
                          children:[
                            Icon(Icons.admin_panel_settings,color:pink),
                            SizedBox(width:10),
                            Text("Role : Administrator"),
                          ],
                        ),

                      ],
                    ),
                  ),

                  const SizedBox(height:30),

                  SizedBox(
                    width:double.infinity,
                    height:55,

                    child:ElevatedButton.icon(
                      icon:const Icon(Icons.logout),

                      label:const Text(
                        "Logout",
                        style:TextStyle(
                          fontSize:17,
                          fontWeight:FontWeight.bold,
                        ),
                      ),

                      onPressed:()async{

                        await supabase.auth.signOut();

                        if(!context.mounted)return;

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder:(_)=>const LoginScreen(),
                          ),
                        );

                      },

                    ),

                  ),

                ],
              ),

            ),

          ),

        ),

      ),

    );

  }

}