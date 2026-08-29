import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_colors.dart';
import '../models/product_model.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../routes/app_routes.dart';


class ProductDetailScreen extends StatefulWidget{
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState()=>_ProductDetailScreenState();
}


class _ProductDetailScreenState extends State<ProductDetailScreen>{
  int quantity=1;

  @override
  Widget build(BuildContext context){
    final cartProvider=Provider.of<CartProvider>(context);
    final authProvider=Provider.of<AuthProvider>(context);
    final String? userId = authProvider.user?.id;

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
            // Product Image
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: widget.product.imageUrl.isNotEmpty 
                ? Image.network(
                    widget.product.imageUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stack) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                          const SizedBox(height: 10),
                          const Text("Image load nahi ho saki", style: TextStyle(color: Colors.grey)),
                        // Debugging link for you
                        TextButton(
                          onPressed: () => debugPrint("IMAGE URL: ${widget.product.imageUrl}"),
                          child: const Text("Check URL in Console", style: TextStyle(fontSize: 10)),
                        ),
                        ],
                      );
                    },
                  )
                : const Icon(Icons.image, size: 80, color: Colors.grey),
              ),
            ),

            const SizedBox(height:20),
            Text(widget.product.name, style:const TextStyle(fontSize:24, fontWeight:FontWeight.bold)),
            const SizedBox(height:10),
            Text("\$${widget.product.price}", style:TextStyle(fontSize:20, color:AppColors.primary, fontWeight:FontWeight.bold)),
            const SizedBox(height:15),
            Text(widget.product.description, style: const TextStyle(fontSize: 16, color: Colors.black87)),
            const SizedBox(height:20),

            Row(
              children:[
                IconButton(
                  onPressed:(){ if(quantity>1) setState(()=>quantity--); },
                  icon:const Icon(Icons.remove_circle, size: 30),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text("$quantity", style:const TextStyle(fontSize:22, fontWeight:FontWeight.bold)),
                ),
                IconButton(
                  onPressed:(){ setState(()=>quantity++); },
                  icon:const Icon(Icons.add_circle, size: 30),
                ),
              ],
            ),

            const SizedBox(height:30),
            SizedBox(
              width:double.infinity,
              child:ElevatedButton.icon(
                onPressed:() async {
                  if (userId == null) { Navigator.pushNamed(context, AppRoutes.login); return; }
                  try {
                    await cartProvider.addItem(userId:userId, productId:widget.product.id, quantity:quantity);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text("Added to Cart"), backgroundColor: Colors.green));
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
                  }
                },
                icon:const Icon(Icons.shopping_cart),
                label:const Text("ADD TO CART", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
