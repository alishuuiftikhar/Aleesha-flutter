import 'package:flutter/material.dart';
import '../services/category_service.dart';
import '../theme/app_colors.dart';

class AddCategoryScreen extends StatefulWidget{

  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState()=>_AddCategoryScreenState();

}


class _AddCategoryScreenState extends State<AddCategoryScreen>{

  final controller=TextEditingController();

  bool loading=false;



  @override
  void dispose(){

    controller.dispose();

    super.dispose();

  }



  Future<void> saveCategory() async{


    if(controller.text.trim().isEmpty){

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content:Text("Enter Category Name"),
        ),

      );

      return;

    }



    setState(()=>loading=true);



    try{


      await CategoryService.addCategory(

        controller.text.trim(),

      );



      if(!mounted)return;



      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content:Text("Category Added Successfully"),
        ),

      );



      controller.clear();



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
        const Text("Add Category"),

      ),



      body:Padding(

        padding:
        const EdgeInsets.all(20),


        child:Column(

          children:[


            TextField(

              controller:controller,

              decoration:
              const InputDecoration(

                labelText:"Category Name",

                border:
                OutlineInputBorder(),

              ),

            ),



            const SizedBox(height:20),



            SizedBox(

              width:double.infinity,

              height:55,


              child:ElevatedButton(


                onPressed:
                loading?null:saveCategory,


                child:loading

                    ?const CircularProgressIndicator(
                  color:Colors.white,
                )

                    :const Text(
                  "Save Category",
                ),


              ),

            ),


          ],


        ),


      ),

    );


  }


}
