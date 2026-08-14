import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CartItemCard extends StatelessWidget {

  final String name;
  final String image;
  final double price;
  final int quantity;

  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;


  const CartItemCard({
    super.key,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });


  @override
  Widget build(BuildContext context){

    return Card(

      child: Padding(

        padding: const EdgeInsets.all(10),

        child: Row(

          children: [

            ClipRRect(

              borderRadius: BorderRadius.circular(10),

              child: Image.network(
                image,
                width:80,
                height:80,
                fit:BoxFit.cover,
              ),

            ),


            const SizedBox(width:12),


            Expanded(

              child: Column(

                crossAxisAlignment:CrossAxisAlignment.start,

                children: [

                  Text(
                    name,
                    style:const TextStyle(
                      fontSize:16,
                      fontWeight:FontWeight.bold,
                    ),
                  ),


                  const SizedBox(height:8),


                  Text(
                    "\$${price.toStringAsFixed(2)}",
                    style:TextStyle(
                      color:AppColors.primary,
                      fontWeight:FontWeight.bold,
                    ),
                  ),


                  Row(

                    children: [

                      IconButton(
                        onPressed:onDecrease,
                        icon:const Icon(Icons.remove),
                      ),


                      Text(
                        quantity.toString(),
                        style:const TextStyle(
                          fontSize:16,
                        ),
                      ),


                      IconButton(
                        onPressed:onIncrease,
                        icon:const Icon(Icons.add),
                      ),


                    ],

                  ),

                ],

              ),

            ),


            IconButton(

              onPressed:onRemove,

              icon:const Icon(
                Icons.delete,
                color:Colors.red,
              ),

            )

          ],

        ),

      ),

    );

  }
}