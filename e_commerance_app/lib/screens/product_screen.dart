import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/product_model.dart';
import '../services/card_service.dart';
class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailScreen({super.key,
    required this.product,
  });
  @override
  State<ProductDetailScreen> createState()=>_ProductDetailScreenState();}
class _ProductDetailScreenState extends State<ProductDetailScreen>{
  int quantity=1;
  final String userId="CURRENT_USER_ID";
  Future<void> addToCart() async{
    await CartService.addToCart(
      userId:userId,
      productId:widget.product.id,
      quantity:quantity,);
    if(!mounted)return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:Text(
          "Added to Cart",),),);}
  @override
  Widget build(BuildContext context){
    final product=widget.product;
    return Scaffold(
      backgroundColor:
      AppColors.background,
      appBar:AppBar(
        backgroundColor:
        AppColors.primary,
        title:Text(product.name),
        centerTitle:true,),
      body:SingleChildScrollView(
        padding:
        const EdgeInsets.all(20),
        child:Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children:[
            Center(
              child:SizedBox(
                height:250,
                child:Image.network(
                  product.image,
                  fit:BoxFit.contain,),)),
            const SizedBox(height:25),
            Text(
              product.name,
              style:
              const TextStyle(
                fontSize:25,
                fontWeight:
                FontWeight.bold,),),
            const SizedBox(height:10),
            Text(
              "\$${product.price}",
              style:
              const TextStyle(
                fontSize:22,
                color:
                AppColors.primary,
                fontWeight:
                FontWeight.bold,),),
            const SizedBox(height:20),
            const Text(
              "Description",
              style:
              TextStyle(
                fontSize:20,
                fontWeight:
                FontWeight.bold,
              ),
            ),
            const SizedBox(height:8),
            Text(
              product.description,
              style:
              const TextStyle(
                fontSize:16,
                color:
                AppColors.grey,
              ),
            ),
            const SizedBox(height:25),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children:[
                const Text(
                  "Quantity",
                  style:
                  TextStyle(
                    fontSize:18,
                    fontWeight:
                    FontWeight.bold,),),
                Row(
                  children:[
                    IconButton(
                      onPressed:(){
                        if(quantity>1){
                          setState((){
                            quantity--;});}},
                      icon:
                      const Icon(
                        Icons.remove_circle,),
                    ),
                    Text(
                      "$quantity",
                      style:
                      const TextStyle(
                        fontSize:18,
                        fontWeight:
                        FontWeight.bold,),),
                    IconButton(
                      onPressed:(){
                        setState((){
                          quantity++;
                        });},
                      icon:
                      const Icon(
                        Icons.add_circle,),),],)],), const SizedBox(height:30),
            SizedBox(
              width:
              double.infinity,
              height:55,
              child:ElevatedButton(
                onPressed:addToCart,
                child:
                const Text(
                  "Add To Cart",
                  style:
                  TextStyle(
                    fontSize:17,),),),)],),),);


  }


}