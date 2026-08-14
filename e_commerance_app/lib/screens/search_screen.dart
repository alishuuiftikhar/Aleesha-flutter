import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/product_card.dart';
import '../widgets/loading_widget.dart';
import '../services/search_service.dart';
import '../models/product_model.dart';
import 'product_detail_screen.dart';


class SearchScreen extends StatefulWidget{

  const SearchScreen({super.key});


  @override
  State<SearchScreen> createState()=>_SearchScreenState();

}


class _SearchScreenState extends State<SearchScreen>{


  final searchController = TextEditingController();

  List<ProductModel> products=[];

  bool loading=false;



  Future<void> search() async{


    setState((){

      loading=true;

    });


    final data =
    await SearchService.searchProducts(
      searchController.text.trim(),
    );


    setState((){

      products=data
          .map((e)=>ProductModel.fromJson(e))
          .toList();

      loading=false;

    });


  }



  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor:AppColors.background,


      appBar:AppBar(

        backgroundColor:AppColors.primary,

        title:const Text(
          "Search Products",
        ),

      ),


      body:Padding(

        padding:const EdgeInsets.all(16),


        child:Column(

          children:[


            TextField(

              controller:searchController,


              decoration:InputDecoration(

                hintText:"Search product",

                prefixIcon:
                const Icon(Icons.search),


                suffixIcon:IconButton(

                  icon:
                  const Icon(Icons.send),

                  onPressed:search,

                ),

              ),

            ),



            const SizedBox(height:20),



            Expanded(

              child:loading

                  ? const LoadingWidget()


                  :GridView.builder(

                itemCount:products.length,


                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(

                  crossAxisCount:2,

                  childAspectRatio:0.7,

                  crossAxisSpacing:10,

                  mainAxisSpacing:10,

                ),


                itemBuilder:(context,index){


                  final product=products[index];


                  return ProductCard(

                    name:product.name,

                    price:product.price,


                    onTap:(){

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder:(_)=>
                              ProductDetailScreen(
                                product:product,
                              ),

                        ),

                      );

                    },

                  );


                },

              ),

            )

          ],

        ),

      ),

    );

  }

}