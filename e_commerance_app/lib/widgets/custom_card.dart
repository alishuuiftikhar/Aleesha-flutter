import 'package:flutter/material.dart';
import '../theme/app_colors.dart';


class CustomCard extends StatelessWidget{


  final Widget child;
  final VoidCallback? onTap;


  const CustomCard({

    super.key,

    required this.child,

    this.onTap,

  });



  @override
  Widget build(BuildContext context){


    return InkWell(

      onTap:onTap,

      borderRadius:
      BorderRadius.circular(12),


      child:Card(

        color:AppColors.card,

        elevation:3,


        shape:RoundedRectangleBorder(

          borderRadius:
          BorderRadius.circular(12),

        ),



        child:Padding(

          padding:
          const EdgeInsets.all(15),


          child:child,

        ),


      ),


    );


  }

}