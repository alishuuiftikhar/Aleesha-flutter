import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget{

  final String name;
  final String image;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.name,
    required this.image,
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

              ClipRRect(
                borderRadius:BorderRadius.circular(8),
                child:Image.network(
                  image,
                  height:40,
                  width:40,
                  fit:BoxFit.cover,
                  loadingBuilder:(context,child,loadingProgress){
                    if(loadingProgress==null)return child;
                    return const CircularProgressIndicator(strokeWidth:2);
                  },
                  errorBuilder:(context,error,stackTrace)=>const Icon(Icons.category,size:30),
                ),
              ),

              const SizedBox(height:8),

              Text(

                name,

                textAlign:TextAlign.center,

                maxLines:2,

                overflow:TextOverflow.ellipsis,

                style:const TextStyle(
                  fontSize:12,
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