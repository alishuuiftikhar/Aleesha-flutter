import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_colors.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';


class ProductDetailScreen extends StatefulWidget{

  final ProductModel product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState()=>_ProductDetailScreenState();

}


class _ProductDetailScreenState extends State<ProductDetailScreen>{

  int quantity=1;

  final String userId="CURRENT_USER_ID";


  @override
  Widget build(BuildContext context){

    final cartProvider=Provider.of<CartProvider>(context);

    final wishlistProvider=Provider.of<WishlistProvider>(context);


    return Scaffold(

      backgroundColor:AppColors.background,

      appBar:AppBar(
        backgroundColor:AppColors.primary,
        title:Text(widget.product.name),
      ),

      body:SingleChildScrollView(

        padding:const EdgeInsets.all(16),

        child:Column(

          crossAxisAlignment:CrossAxisAlignment.start,

          children:[



            const SizedBox(height:20),

            Text(
              widget.product.name,
              style:const TextStyle(
                fontSize:24,
                fontWeight:FontWeight.bold,
              ),
            ),

            const SizedBox(height:10),

            Text(
              "\$${widget.product.price}",
              style:TextStyle(
                fontSize:20,
                color:AppColors.primary,
                fontWeight:FontWeight.bold,
              ),
            ),

            const SizedBox(height:15),

            Text(widget.product.description),

            const SizedBox(height:20),

            Row(
              children:[

                IconButton(
                  onPressed:(){
                    if(quantity>1){
                      setState(()=>quantity--);
                    }
                  },
                  icon:const Icon(Icons.remove_circle),
                ),

                Text(
                  "$quantity",
                  style:const TextStyle(
                    fontSize:20,
                    fontWeight:FontWeight.bold,
                  ),
                ),

                IconButton(
                  onPressed:(){
                    setState(()=>quantity++);
                  },
                  icon:const Icon(Icons.add_circle),
                ),

              ],
            ),

            const SizedBox(height:20),

            SizedBox(
              width:double.infinity,

              child:ElevatedButton.icon(

                onPressed:() async{

                  await cartProvider.addItem(
                    userId:userId,
                    productId:widget.product.id,
                    quantity:quantity,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:Text("Added to Cart"),
                    ),
                  );

                },

                icon:const Icon(Icons.shopping_cart),

                label:const Text("Add To Cart"),

              ),
            ),

            const SizedBox(height:10),

            SizedBox(
              width:double.infinity,

              child:OutlinedButton.icon(

                onPressed:(){

                  if(wishlistProvider.isFavorite(widget.product.id)){

                    wishlistProvider.removeWishlist(
                      userId:userId,
                      productId:widget.product.id,
                    );

                  }else{

                    wishlistProvider.addWishlist(
                      userId:userId,
                      productId:widget.product.id,
                    );

                  }

                },

                icon:const Icon(Icons.favorite),

                label:const Text("Wishlist"),

              ),
            ),

          ],

        ),

      ),

    );

  }

}