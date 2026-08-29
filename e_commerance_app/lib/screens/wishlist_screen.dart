import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../widgets/loading_widget.dart';
import '../services/wishlist_service.dart';
import '../services/card_service.dart';
import '../providers/auth_provider.dart';

class WishlistScreen extends StatefulWidget{
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState()=>_WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen>{

  List<Map<String,dynamic>> items=[];
  bool loading=true;

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadWishlist();
    });
  }

  Future<void> loadWishlist() async{
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String? userId = authProvider.user?.id;

    if (userId == null) {
      if (mounted) setState(() => loading = false);
      return;
    }

    try {
      final data = await WishlistService.getWishlist(userId);
      if (mounted) {
        setState((){
          items = data;
          loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> removeItem(int id) async{
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String? userId = authProvider.user?.id;

    if (userId == null) return;

    await WishlistService.removeFromWishlist(
      userId:userId,
      productId:id,
    );
    loadWishlist();
  }

  Future<void> addToCart(int id) async{
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final String? userId = authProvider.user?.id;

    if (userId == null) return;

    await CartService.addToCart(
      userId:userId,
      productId:id,
      quantity:1,
    );

    if (!mounted) return;

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

          // Safety Check: If product data is missing
          if (product == null) {
            return const SizedBox.shrink();
          }

          return Card(
            child:ListTile(
              leading:SizedBox(
                width:60,
                child: (product['image'] != null && product['image'].toString().isNotEmpty)
                  ? Image.network(
                      product['image'],
                      fit:BoxFit.cover,
                      loadingBuilder:(context,child,loadingProgress){
                        if(loadingProgress==null)return child;
                        return const Center(child:CircularProgressIndicator(strokeWidth:2));
                      },
                      errorBuilder:(context,error,stackTrace)=>const Icon(Icons.image_not_supported),
                    )
                  : const Icon(Icons.image),
              ),
              title:Text(product['name'] ?? "Unknown Product"),
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
                    icon:const Icon(Icons.delete, color: Colors.red),
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
