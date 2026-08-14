import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';
import '../theme/app_colors.dart';

class CategoryListScreen extends StatefulWidget{

  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState()=>_CategoryListScreenState();

}


class _CategoryListScreenState extends State<CategoryListScreen>{

  List<CategoryModel> categories=[];

  bool loading=true;



  @override
  void initState(){

    super.initState();

    loadCategories();

  }



  Future<void> loadCategories() async{

    setState(()=>loading=true);


    final data=
    await CategoryService.getCategories();


    setState((){

      categories=data;

      loading=false;

    });


  }




  Future<void> deleteCategory(int id) async{


    await CategoryService.deleteCategory(id);


    loadCategories();


  }




  @override
  Widget build(BuildContext context){


    return Scaffold(

      backgroundColor:
      AppColors.background,


      appBar:AppBar(

        title:
        const Text("Categories"),

      ),



      body:loading


          ?const Center(

        child:CircularProgressIndicator(),

      )


          :categories.isEmpty


          ?const Center(

        child:Text(
          "No Categories Found",
        ),

      )


          :ListView.builder(

        padding:
        const EdgeInsets.all(15),


        itemCount:
        categories.length,


        itemBuilder:(context,index){


          final category=
          categories[index];



          return Card(


            child:ListTile(


              title:
              Text(
                category.name,
              ),



              subtitle:
              Text(
                "ID : ${category.id}",
              ),



              trailing:
              IconButton(


                icon:
                const Icon(

                  Icons.delete,

                  color:Colors.red,

                ),



                onPressed:(){


                  if(category.id!=null){

                    deleteCategory(
                      category.id!,
                    );

                  }


                },


              ),


            ),


          );


        },


      ),


    );


  }


}