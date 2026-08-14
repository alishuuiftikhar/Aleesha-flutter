import 'package:flutter/material.dart';
import '../theme/app_colors.dart';


class ErrorWidgetView extends StatelessWidget{


  final String message;
  final VoidCallback onRetry;


  const ErrorWidgetView({

    super.key,

    required this.message,

    required this.onRetry,

  });



  @override
  Widget build(BuildContext context){


    return Center(

      child:Column(

        mainAxisAlignment:
        MainAxisAlignment.center,


        children:[


          const Icon(

            Icons.error_outline,

            size:80,

            color:AppColors.error,

          ),



          const SizedBox(height:15),



          Text(

            message,

            textAlign:TextAlign.center,

            style:const TextStyle(

              fontSize:17,

              color:AppColors.grey,

            ),

          ),



          const SizedBox(height:20),



          ElevatedButton(

            onPressed:onRetry,

            child:const Text(

              "Try Again",

            ),

          )


        ],

      ),

    );


  }

}