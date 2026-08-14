import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'admin_home_screen.dart';


class AdminLoginScreen extends StatefulWidget{

  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState()=>_AdminLoginScreenState();

}



class _AdminLoginScreenState extends State<AdminLoginScreen>{


  final emailController =
  TextEditingController();


  final passwordController =
  TextEditingController();


  bool loading=false;



  Future<void> login() async{


    if(emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty){

      return;

    }


    setState(()=>loading=true);



    try{


      final response =
      await Supabase.instance.client.auth
          .signInWithPassword(

        email:
        emailController.text.trim(),

        password:
        passwordController.text.trim(),

      );



      final user =
          response.user;



      if(user==null){

        throw Exception("Login Failed");

      }



      final role =
      user.userMetadata?['role'];



      if(role=="admin"){



        if(!mounted)return;



        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder:(_)=>
            const AdminHomeScreen(),

          ),

        );



      }else{



        await Supabase.instance.client.auth.signOut();



        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content:
            Text(
              "You are not an Admin",
            ),

          ),

        );

      }



    }catch(e){



      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content:
          Text(
            e.toString(),
          ),

        ),

      );

    }



    setState(()=>loading=false);


  }





  @override
  void dispose(){

    emailController.dispose();

    passwordController.dispose();

    super.dispose();

  }







  @override
  Widget build(BuildContext context){


    return Scaffold(


      appBar:
      AppBar(

        title:
        const Text(
          "Admin Login",
        ),

      ),



      body:
      Padding(

        padding:
        const EdgeInsets.all(20),


        child:
        Column(

          children:[



            TextField(

              controller:
              emailController,

              decoration:
              const InputDecoration(

                labelText:
                "Email",

              ),

            ),




            const SizedBox(height:15),




            TextField(

              controller:
              passwordController,

              obscureText:true,

              decoration:
              const InputDecoration(

                labelText:
                "Password",

              ),

            ),




            const SizedBox(height:25),




            SizedBox(

              width:
              double.infinity,


              height:
              55,



              child:
              ElevatedButton(


                onPressed:
                loading?null:login,



                child:


                loading

                    ?const CircularProgressIndicator(
                  color:Colors.white,
                )


                    :const Text(
                  "Login",
                ),



              ),

            ),



          ],

        ),

      ),


    );


  }


}