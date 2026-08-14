import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget{

  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState()=>_SignupScreenState();

}


class _SignupScreenState extends State<SignupScreen>{

  final emailController=TextEditingController();
  final passwordController=TextEditingController();

  bool loading=false;


  Future<void> signup() async{

    if(emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty){

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:Text("Please enter email and password"),
        ),
      );

      return;
    }


    setState(()=>loading=true);


    try{

      await AuthService.signUp(
        email:emailController.text.trim(),
        password:passwordController.text.trim(),
      );


      if(!mounted)return;


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:Text("Account Created Successfully"),
        ),
      );


      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:(_)=>const LoginScreen(),
        ),
      );


    }catch(e){

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:Text(e.toString()),
        ),
      );

    }


    setState(()=>loading=false);

  }



  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor:AppColors.background,

      appBar:AppBar(

        backgroundColor:AppColors.primary,

        title:const Text("Create Account"),

        centerTitle:true,

      ),


      body:Padding(

        padding:const EdgeInsets.all(20),

        child:Column(

          mainAxisAlignment:MainAxisAlignment.center,

          children:[


            CustomTextField(

              controller:emailController,

              hintText:"Email",

              prefixIcon:Icons.email,

            ),


            const SizedBox(height:15),


            CustomTextField(

              controller:passwordController,

              hintText:"Password",

              prefixIcon:Icons.lock,

              obscureText:true,

            ),


            const SizedBox(height:25),


            CustomButton(

              text:"Sign Up",

              isLoading:loading,

              onPressed:signup,

            ),


            TextButton(

              onPressed:(){

                Navigator.pushReplacement(

                  context,

                  MaterialPageRoute(

                    builder:(_)=>const LoginScreen(),

                  ),

                );

              },

              child:const Text(
                "Already have an account? Login",
              ),

            ),

          ],

        ),

      ),

    );

  }

}