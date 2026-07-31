import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';
import '../services/product_service.dart';
import '../theme/app_colors.dart';

class AddProductScreen extends StatefulWidget{

  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState()=>_AddProductScreenState();

}


class _AddProductScreenState extends State<AddProductScreen>{

  final nameController=TextEditingController();
  final priceController=TextEditingController();
  final descriptionController=TextEditingController();

  List<CategoryModel> categories=[];

  CategoryModel? selectedCategory;

  bool loading=false;


  @override
  void initState(){

    super.initState();

    loadCategories();

  }


  @override
  void dispose(){

    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();

    super.dispose();

  }


  Future<void> loadCategories() async{

    final data=
    await CategoryService.getCategories();

    setState((){

      categories=data;

    });

  }


  Future<void> saveProduct() async{

    if(nameController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        selectedCategory==null){

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content:Text("Please fill all fields"),
        ),

      );

      return;

    }


    setState(()=>loading=true);


    try{

      await ProductService.addProduct(

        name:nameController.text.trim(),

        price:double.parse(
          priceController.text.trim(),
        ),

        description:
        descriptionController.text.trim(),

        categoryId:
        selectedCategory!.id!,

      );


      if(!mounted)return;


      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content:Text("Product Added Successfully"),
        ),

      );


      nameController.clear();
      priceController.clear();
      descriptionController.clear();


      setState((){

        selectedCategory=null;

      });


    }catch(e){

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(
          content:Text(e.toString()),
        ),

      );

    }


    setState(()=>loading=false);

  }



  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor:
      AppColors.background,


      appBar:AppBar(

        title:
        const Text("Add Product"),

      ),


      body:SingleChildScrollView(

        padding:
        const EdgeInsets.all(20),


        child:Column(

          children:[


            TextField(

              controller:nameController,

              decoration:
              const InputDecoration(
                labelText:"Product Name",
              ),

            ),


            const SizedBox(height:15),


            TextField(

              controller:priceController,

              keyboardType:
              TextInputType.number,

              decoration:
              const InputDecoration(
                labelText:"Price",
              ),

            ),


            const SizedBox(height:15),


            TextField(

              controller:descriptionController,

              maxLines:4,

              decoration:
              const InputDecoration(
                labelText:"Description",
              ),

            ),


            const SizedBox(height:15),


            DropdownButtonFormField<CategoryModel>(

              value:selectedCategory,

              decoration:
              const InputDecoration(
                labelText:"Category",
              ),


              items:categories.map((category){

                return DropdownMenuItem(

                  value:category,

                  child:Text(
                    category.name,
                  ),

                );

              }).toList(),


              onChanged:(value){

                setState((){

                  selectedCategory=value;

                });

              },

            ),


            const SizedBox(height:25),


            SizedBox(

              width:double.infinity,

              height:55,


              child:ElevatedButton(

                onPressed:
                loading?null:saveProduct,


                child:loading

                    ?const CircularProgressIndicator(
                  color:Colors.white,
                )

                    :const Text(
                  "Save Product",
                ),

              ),

            ),


          ],

        ),

      ),

    );

  }

}