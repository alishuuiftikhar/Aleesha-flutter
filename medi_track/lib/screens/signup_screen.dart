import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class SignupScreen extends StatefulWidget{
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState()=>_SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>{

  final nameController=TextEditingController();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();

  final supabase=Supabase.instance.client;

  bool isLoading=false;
  bool obscurePassword=true;

  final pink=const Color(0xFFEC4899);


  Future<void> signup()async{

    if(nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty){

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:Text("Please fill all fields"),
        ),
      );

      return;
    }


    setState((){
      isLoading=true;
    });


    try{

      final response=await supabase.auth.signUp(

        email:emailController.text.trim(),

        password:passwordController.text.trim(),

        data:{
          "full_name":nameController.text.trim(),
        },

      );


      if(response.user!=null){

        final prefs=
        await SharedPreferences.getInstance();


        await prefs.setString(
          "email",
          emailController.text.trim(),
        );


        await prefs.setString(
          "password",
          passwordController.text.trim(),
        );


        if(!mounted)return;


        ScaffoldMessenger.of(context).showSnackBar(

          const SnackBar(

            content:Text(
              "Account Created Successfully",
            ),

          ),

        );


        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder:(_)=>const LoginScreen(),

          ),

        );

      }


    }
    catch(e){

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content:Text(
            e.toString(),
          ),

        ),

      );

    }


    setState((){
      isLoading=false;
    });

  }



  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor:Colors.white,

      body:SafeArea(

        child:SingleChildScrollView(

          padding:const EdgeInsets.all(20),

          child:Column(

            children:[


              const SizedBox(height:35),


              CircleAvatar(

                radius:60,

                backgroundColor:pink,

                child:const Icon(

                  Icons.local_hospital,

                  size:60,

                  color:Colors.white,

                ),

              ),


              const SizedBox(height:25),


              const Text(

                "Create Account",

                style:TextStyle(

                  fontSize:30,

                  fontWeight:FontWeight.bold,

                ),

              ),


              const SizedBox(height:8),


              const Text(

                "Create your MediTrack account",

                style:TextStyle(

                  color:Colors.grey,

                ),

              ),


              const SizedBox(height:35),



              TextField(

                controller:nameController,

                decoration:input(
                  "Full Name",
                  Icons.person_outline,
                ),

              ),


              const SizedBox(height:15),



              TextField(

                controller:emailController,

                keyboardType:
                TextInputType.emailAddress,

                decoration:input(
                  "Email Address",
                  Icons.email_outlined,
                ),

              ),


              const SizedBox(height:15),



              TextField(

                controller:passwordController,

                obscureText:obscurePassword,


                decoration:InputDecoration(

                  labelText:"Password",

                  prefixIcon:Icon(
                    Icons.lock_outline,
                    color:pink,
                  ),


                  suffixIcon:IconButton(

                    icon:Icon(

                      obscurePassword
                          ?Icons.visibility_off
                          :Icons.visibility,

                      color:pink,

                    ),


                    onPressed:(){

                      setState((){

                        obscurePassword=
                        !obscurePassword;

                      });

                    },

                  ),


                  border:OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(15),

                  ),

                ),

              ),



              const SizedBox(height:25),



              SizedBox(

                width:double.infinity,

                height:55,


                child:ElevatedButton(

                  onPressed:
                  isLoading?null:signup,


                  style:ElevatedButton.styleFrom(

                    backgroundColor:pink,

                    foregroundColor:Colors.white,


                    shape:RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(15),

                    ),

                  ),


                  child:isLoading

                      ?const CircularProgressIndicator(
                    color:Colors.white,
                  )

                      :const Text(

                    "Create Account",

                    style:TextStyle(

                      fontSize:18,

                      fontWeight:FontWeight.bold,

                    ),

                  ),

                ),

              ),



              const SizedBox(height:20),



              Row(

                mainAxisAlignment:
                MainAxisAlignment.center,

                children:[


                  const Text(
                    "Already have an account? ",
                  ),


                  TextButton(

                    onPressed:(){

                      Navigator.pushReplacement(

                        context,

                        MaterialPageRoute(

                          builder:(_)=>
                          const LoginScreen(),

                        ),

                      );

                    },


                    child:Text(

                      "Login",

                      style:TextStyle(

                        color:pink,

                      ),

                    ),

                  ),

                ],

              ),

            ],

          ),

        ),

      ),

    );

  }



  InputDecoration input(
      String text,
      IconData icon
      ){

    return InputDecoration(

      labelText:text,

      prefixIcon:Icon(

        icon,

        color:pink,

      ),


      border:OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(15),

      ),

    );

  }



  @override
  void dispose(){

    nameController.dispose();

    emailController.dispose();

    passwordController.dispose();

    super.dispose();

  }

}