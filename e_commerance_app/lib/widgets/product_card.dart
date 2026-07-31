import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget{

  final String name;
  final double price;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context){

    return InkWell(

      onTap:onTap,

      borderRadius:BorderRadius.circular(12),

      child:Card(

        elevation:3,

        shape:RoundedRectangleBorder(
          borderRadius:BorderRadius.circular(12),
        ),

        child:Padding(

          padding:const EdgeInsets.all(12),

          child:Column(

            mainAxisAlignment:MainAxisAlignment.center,

            children:[

              const Icon(
                Icons.shopping_bag,
                size:60,
                color:Colors.deepPurple,
              ),

              const SizedBox(height:15),

              Text(
                name,
                textAlign:TextAlign.center,
                maxLines:2,
                overflow:TextOverflow.ellipsis,
                style:const TextStyle(
                  fontSize:16,
                  fontWeight:FontWeight.bold,
                ),
              ),

              const SizedBox(height:10),

              Text(
                "\$${price.toStringAsFixed(2)}",
                style:const TextStyle(
                  fontSize:18,
                  color:Colors.green,
                  fontWeight:FontWeight.bold,
                ),
              ),

              const Spacer(),

              SizedBox(

                width:double.infinity,

                child:ElevatedButton(

                  onPressed:onTap,

                  child:const Text("View"),

                ),

              ),

            ],

          ),

        ),

      ),

    );

  }

}