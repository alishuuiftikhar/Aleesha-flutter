import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_colors.dart';

import '../providers/product_provider.dart';
import '../providers/category_provider.dart';

import '../widgets/loading_widget.dart';
import '../widgets/category_card.dart';
import '../widgets/product_card.dart';

import 'product_detail_screen.dart';
import 'category_products_screen.dart';



class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});


  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();

}



class _HomeScreenState extends State<HomeScreen> {


  @override
  void initState() {

    super.initState();


    Future.microtask(() {

      if (!mounted) return;

      Provider.of<ProductProvider>(
        context,
        listen:false,
      ).loadProducts();



      Provider.of<CategoryProvider>(
        context,
        listen:false,
      ).loadCategories();

    });


  }




  @override
  Widget build(BuildContext context) {


    final productProvider =
    Provider.of<ProductProvider>(context);



    final categoryProvider =
    Provider.of<CategoryProvider>(context);




    return Scaffold(


      backgroundColor:
      AppColors.background,



      appBar: AppBar(


        backgroundColor:
        AppColors.primary,


        title:
        const Text(
          "Shop",
        ),


        centerTitle:true,


      ),





      body:


      (productProvider.loading ||
          categoryProvider.loading)


          ? const LoadingWidget()



          : RefreshIndicator(


        onRefresh: () async {


          await productProvider.loadProducts();


          await categoryProvider.loadCategories();


        },


        child: SingleChildScrollView(


          physics: const AlwaysScrollableScrollPhysics(),


          padding:
          const EdgeInsets.all(15),



          child:Column(


            crossAxisAlignment:
            CrossAxisAlignment.start,



            children:[



              const Text(

                "Categories",

                style:
                TextStyle(

                  fontSize:20,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),



              const SizedBox(height:15),




              SizedBox(


                height:140,



                child:ListView.builder(


                  scrollDirection:
                  Axis.horizontal,



                  itemCount:
                  categoryProvider.categories.length,



                  itemBuilder:(context,index){



                    final category =
                    categoryProvider.categories[index];



                    return SizedBox(


                      width:110,



                      child:CategoryCard(


                        name:
                        category.name,



                        image:
                        category.image,



                        onTap:(){



                          Navigator.push(


                            context,


                            MaterialPageRoute(


                              builder:(context)=>

                                  CategoryProductsScreen(


                                    categoryId:
                                    category.id,


                                    categoryName:
                                    category.name,


                                  ),


                            ),


                          );


                        },


                      ),



                    );



                  },



                ),


              ),




              const SizedBox(height:25),




              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Products",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => productProvider.loadProducts(),
                    icon: const Icon(Icons.refresh, color: AppColors.primary),
                  ),
                ],
              ),




              const SizedBox(height:15),




              productProvider.products.isEmpty


                  ? Center(


                child:Column(


                  children:[


                    const Text("No products found"),


                    TextButton(


                      onPressed:()=>productProvider.loadProducts(),


                      child:const Text("Refresh"),


                    ),


                  ],


                ),


              )


                  : GridView.builder(


                shrinkWrap:true,


                physics:
                const NeverScrollableScrollPhysics(),



                itemCount:
                productProvider.products.length,



                gridDelegate:

                const SliverGridDelegateWithFixedCrossAxisCount(

                  crossAxisCount:2,

                  childAspectRatio:0.7,

                  crossAxisSpacing:10,

                  mainAxisSpacing:10,

                ),




                itemBuilder:(context,index){



                  final product =
                  productProvider.products[index];




                  return ProductCard(


                    name:
                    product.name,



                    imageUrl:
                    product.imageUrl,



                    price:
                    product.price,



                    onTap:(){



                      Navigator.push(


                        context,


                        MaterialPageRoute(


                          builder:(context)=>

                              ProductDetailScreen(

                                product:product,

                              ),


                        ),


                      );



                    },


                  );



                },


              ),



            ],


          ),



        ),


      ),
    );


  }


}