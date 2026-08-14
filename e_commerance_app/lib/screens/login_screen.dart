import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget{

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState()=>_LoginScreenState();

}


class _LoginScreenState extends State<LoginScreen>{

  final emailController=TextEditingController();
  final passwordController=TextEditingController();

  bool obscureText=true;


  Future<void> login() async{

    try{

      await AuthService.login(
        email:emailController.text.trim(),
        password:passwordController.text.trim(),
      );


      if(!mounted)return;


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:Text("Login Successful"),
        ),
      );


      Navigator.pushReplacementNamed(
        context,
        AppRoutes.home,
      );


    }catch(e){

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:Text(e.toString()),
        ),
      );

    }

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

      appBar:AppBar(
        title:const Text("Login"),
      ),


      body:SafeArea(

        child:SingleChildScrollView(

          padding:const EdgeInsets.all(20),

          child:Column(

            children:[


              const SizedBox(height:40),


              const Icon(
                Icons.shopping_bag_rounded,
                size:90,
                color:Colors.deepPurple,
              ),


              const SizedBox(height:20),


              const Text(
                "Welcome Back",
                style:TextStyle(
                  fontSize:28,
                  fontWeight:FontWeight.bold,
                ),
              ),


              const SizedBox(height:40),


              TextField(

                controller:emailController,

                keyboardType:TextInputType.emailAddress,

                decoration:const InputDecoration(
                  labelText:"Email",
                  prefixIcon:Icon(Icons.email),
                ),

              ),


              const SizedBox(height:20),


              TextField(

                controller:passwordController,

                obscureText:obscureText,

                decoration:InputDecoration(

                  labelText:"Password",

                  prefixIcon:const Icon(Icons.lock),

                  suffixIcon:IconButton(

                    onPressed:(){

                      setState((){

                        obscureText=!obscureText;

                      });

                    },

                    icon:Icon(
                      obscureText
                          ?Icons.visibility
                          :Icons.visibility_off,
                    ),

                  ),

                ),

              ),


              const SizedBox(height:20),


              SizedBox(

                width:double.infinity,

                height:55,

                child:ElevatedButton(

                  onPressed:login,

                  child:const Text(
                    "Login",
                    style:TextStyle(
                      fontSize:18,
                    ),
                  ),

                ),

              ),


              const SizedBox(height:30),


              Row(

                mainAxisAlignment:MainAxisAlignment.center,

                children:[


                  const Text(
                    "Don't have an account?",
                  ),


                  TextButton(

                    onPressed:(){

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder:(_)=>const SignupScreen(),

                        ),

                      );

                    },

                    child:const Text(
                      "Sign Up",
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

}