import 'package:flutter/material.dart';
import '../theme/app_colors.dart';


class EmptyWidget extends StatelessWidget{


  final String message;
  final IconData icon;


  const EmptyWidget({

    super.key,

    required this.message,

    this.icon = Icons.inbox,

  });



  @override
  Widget build(BuildContext context){


    return Center(

      child:Column(

        mainAxisAlignment:
        MainAxisAlignment.center,


        children:[


          Icon(

            icon,

            size:80,

            color:AppColors.grey,

          ),



          const SizedBox(height:15),



          Text(

            message,

            textAlign:TextAlign.center,

            style:const TextStyle(

              fontSize:18,

              color:AppColors.grey,

            ),

          )


        ],

      ),

    );


  }

}