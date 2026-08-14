import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomButton extends StatelessWidget{

  final String text;
  final VoidCallback onPressed;
  final bool loading;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.loading=false,
  });

  @override
  Widget build(BuildContext context){

    return SizedBox(

      width:double.infinity,
      height:55,

      child:ElevatedButton(

        onPressed:loading?null:onPressed,

        child:loading
            ?const CircularProgressIndicator(
          color:AppColors.white,
        )
            :Text(text),

      ),

    );

  }

}