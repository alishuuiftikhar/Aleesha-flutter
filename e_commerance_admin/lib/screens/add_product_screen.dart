import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';
import '../services/product_service.dart';
import '../services/storage_service.dart';
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

  XFile? imageFile;
  Uint8List? imageBytes;

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


  Future<void> loadCategories() async {
    try {
      final data = await CategoryService.getCategories();
      setState(() {
        categories = data;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading categories: $e")),
      );
    }
  }



  Future<void> pickImage() async{

    final picker=ImagePicker();

    final pickedFile=
    await picker.pickImage(

      source:ImageSource.gallery,

    );


    if(pickedFile!=null){
      final bytes = await pickedFile.readAsBytes();
      setState((){
        imageFile=pickedFile;
        imageBytes = bytes;
      });

    }

  }




  Future<void> saveProduct() async{

    if(nameController.text.trim().isEmpty ||
        priceController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty ||
        selectedCategory==null ||
        imageFile==null){

      ScaffoldMessenger.of(context).showSnackBar(

        const SnackBar(
          content:Text("Please fill all fields and select an image"),
        ),

      );

      return;

    }


    setState(()=>loading=true);


    try{


      final imageUrl=
      await StorageService.uploadImage(imageFile!);



      await ProductService.addProduct(

        name:nameController.text.trim(),

        price:double.parse(
          priceController.text.trim(),
        ),

        description:
        descriptionController.text.trim(),

        imageUrl:imageUrl,

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

        imageFile=null;
        imageBytes=null;

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



            GestureDetector(

              onTap:pickImage,

              child:Container(

                height:200,

                width:double.infinity,

                decoration:BoxDecoration(

                  color:Colors.grey[200],

                  borderRadius:
                  BorderRadius.circular(15),

                  border:Border.all(
                    color:Colors.grey,
                  ),

                ),


                child:imageBytes!=null


                    ?ClipRRect(

                  borderRadius:
                  BorderRadius.circular(15),

                  child:Image.memory(

                    imageBytes!,

                    fit:BoxFit.contain,

                  ),

                )


                    :const Column(

                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children:[

                    Icon(
                      Icons.add_a_photo,
                      size:50,
                    ),

                    Text("Pick Product Image"),

                  ],

                ),

              ),

            ),



            const SizedBox(height:20),




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