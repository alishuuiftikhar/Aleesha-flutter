import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/product_card.dart';
import '../widgets/loading_widget.dart';

import '../services/search_service.dart';
import '../models/product_model.dart';

import 'product_detail_screen.dart';



class CategoryProductsScreen extends StatefulWidget {


  final int categoryId;

  final String categoryName;



  const CategoryProductsScreen({

    super.key,

    required this.categoryId,

    required this.categoryName,

  });



  @override
  State<CategoryProductsScreen> createState() =>
      _CategoryProductsScreenState();

}




class _CategoryProductsScreenState
    extends State<CategoryProductsScreen> {



  List<ProductModel> products = [];

  bool loading = true;




  @override
  void initState(){

    super.initState();

    loadProducts();

  }





  Future<void> loadProducts() async {


    try {


      final data =
      await SearchService.filterByCategory(
        widget.categoryId,
      );



      products = data
          .map(

            (item) => ProductModel.fromJson(
          item,
        ),

      )
          .toList();



    } catch(e){


      products = [];


    }




    setState((){

      loading = false;

    });


  }






  @override
  Widget build(BuildContext context){


    return Scaffold(


      backgroundColor:
      AppColors.background,



      appBar:AppBar(


        backgroundColor:
        AppColors.primary,


        title:
        Text(

          widget.categoryName,

        ),


        centerTitle:true,


      ),




      body:



      loading


          ? const LoadingWidget()



          : products.isEmpty


          ? const Center(

        child:
        Text(
          "No Products Found",
        ),

      )



          : GridView.builder(



        padding:
        const EdgeInsets.all(15),



        itemCount:
        products.length,



        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(


          crossAxisCount:2,


          childAspectRatio:0.7,


          crossAxisSpacing:10,


          mainAxisSpacing:10,


        ),




        itemBuilder:(context,index){



          final product =
          products[index];





          return ProductCard(


            name:
            product.name,




            price:
            product.price,



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



    );


  }



}