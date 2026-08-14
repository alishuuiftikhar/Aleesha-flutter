import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../theme/app_colors.dart';
import 'edit_product_screen.dart';

class ProductListScreen extends StatefulWidget{

  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState()=>_ProductListScreenState();

}

class _ProductListScreenState extends State<ProductListScreen>{

  List<ProductModel> products=[];
  bool loading=true;

  @override
  void initState(){

    super.initState();

    loadProducts();

  }


  Future<void> loadProducts() async{

    setState(()=>loading=true);

    final data=
    await ProductService.getProducts();

    setState((){

      products=data;

      loading=false;

    });

  }


  Future<void> deleteProduct(int id) async{

    await ProductService.deleteProduct(id);

    loadProducts();

  }


  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor:AppColors.background,

      appBar:AppBar(

        title:const Text("Products"),

      ),


      body:loading

          ?const Center(
        child:CircularProgressIndicator(),
      )

          :products.isEmpty

          ?const Center(
        child:Text("No Products Found"),
      )

          :ListView.builder(

        padding:const EdgeInsets.all(15),

        itemCount:products.length,

        itemBuilder:(context,index){

          final product=products[index];

          return Card(

            child:ListTile(

              title:Text(
                product.name,
              ),

              subtitle:Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children:[

                  Text(
                    "Price: \$${product.price}",
                  ),

                  Text(
                    product.description,
                  ),

                ],

              ),


              trailing:Row(

                mainAxisSize:
                MainAxisSize.min,

                children:[


                  IconButton(

                    icon:const Icon(
                      Icons.edit,
                      color:Colors.blue,
                    ),

                    onPressed:() async{

                      final result=
                      await Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder:(_)=>
                              EditProductScreen(
                                product:product,
                              ),

                        ),

                      );


                      if(result==true){

                        loadProducts();

                      }

                    },

                  ),



                  IconButton(

                    icon:const Icon(
                      Icons.delete,
                      color:Colors.red,
                    ),

                    onPressed:(){

                      if(product.id!=null){

                        deleteProduct(
                          product.id!,
                        );

                      }

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