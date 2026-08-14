import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget{

  final String name;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context){

    return InkWell(

      onTap:onTap,

      borderRadius:BorderRadius.circular(12),

      child:Card(

        elevation:3,

        child:Padding(

          padding:const EdgeInsets.all(12),

          child:Column(

            mainAxisAlignment:
            MainAxisAlignment.center,

            children:[

              const Icon(
                Icons.category,
                size:35,
                color:Colors.deepPurple,
              ),

              const SizedBox(height:8),

              Text(

                name,

                textAlign:TextAlign.center,

                style:const TextStyle(
                  fontWeight:FontWeight.w600,
                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}