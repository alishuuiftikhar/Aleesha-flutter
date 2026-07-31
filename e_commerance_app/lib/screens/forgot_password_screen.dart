import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../services/auth_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState()=>_ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>{

  final emailController = TextEditingController();

  bool loading = false;


  Future<void> resetPassword() async{

    setState(() {
      loading=true;
    });

    try{

      await AuthService.resetPassword(
        emailController.text.trim(),
      );


      if(!mounted)return;


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Password reset email sent",
          ),
        ),
      );


    }catch(e){

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:Text(
            e.toString(),
          ),
        ),
      );

    }


    setState(() {
      loading=false;
    });

  }


  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor:AppColors.background,


      appBar:AppBar(
        backgroundColor:AppColors.primary,
        title:const Text(
          "Forgot Password",
        ),
        centerTitle:true,
      ),


      body:Padding(

        padding:const EdgeInsets.all(20),

        child:Column(

          mainAxisAlignment:MainAxisAlignment.center,

          children:[


            const Icon(
              Icons.lock_reset,
              size:80,
              color:AppColors.primary,
            ),


            const SizedBox(height:25),


            CustomTextField(
              controller:emailController,
              hintText:"Enter Email",
              prefixIcon:Icons.email,
              keyboardType:TextInputType.emailAddress,
            ),


            const SizedBox(height:25),


            CustomButton(
              text:"Send Reset Link",
              isLoading:loading,
              onPressed:resetPassword,
            ),

          ],
        ),
      ),
    );
  }
}