import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/loading_widget.dart';
import '../services/wishlist_service.dart';
import '../services/card_service.dart';

class WishlistScreen extends StatefulWidget{
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState()=>_WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen>{

  List<Map<String,dynamic>> items=[];
  bool loading=true;
  final String userId="CURRENT_USER_ID";

  @override
  void initState(){
    super.initState();
    loadWishlist();
  }

  Future<void> loadWishlist() async{
    final data=await WishlistService.getWishlist(userId);
    setState((){
      items=data;
      loading=false;
    });
  }

  Future<void> removeItem(int id) async{
    await WishlistService.removeFromWishlist(
      userId:userId,
      productId:id,
    );
    loadWishlist();
  }

  Future<void> addToCart(int id) async{
    await CartService.addToCart(
      userId:userId,
      productId:id,
      quantity:1,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content:Text("Added to Cart")),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor:AppColors.background,
      appBar:AppBar(
        backgroundColor:AppColors.primary,
        title:const Text("Wishlist"),
        centerTitle:true,
      ),
      body:loading
          ? const LoadingWidget()
          :items.isEmpty
          ? const Center(
        child:Text("Your Wishlist is Empty"),
      )
          :ListView.builder(
        padding:const EdgeInsets.all(15),
        itemCount:items.length,
        itemBuilder:(context,index){

          final item=items[index];
          final product=item['products'];

          return Card(
            child:ListTile(
              leading:SizedBox(
                width:60,
                child:Image.network(
                  product['image'],
                  fit:BoxFit.cover,
                ),
              ),
              title:Text(product['name']),
              subtitle:Text("\$${product['price']}"),
              trailing:Row(
                mainAxisSize:MainAxisSize.min,
                children:[
                  IconButton(
                    icon:const Icon(Icons.shopping_cart),
                    onPressed:(){
                      addToCart(product['id']);
                    },
                  ),
                  IconButton(
                    icon:const Icon(Icons.delete),
                    onPressed:(){
                      removeItem(product['id']);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}