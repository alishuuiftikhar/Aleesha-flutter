import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../theme/app_colors.dart';

class EditProductScreen extends StatefulWidget{

  final ProductModel product;

  const EditProductScreen({
    super.key,
    required this.product,
  });

  @override
  State<EditProductScreen> createState()=>_EditProductScreenState();

}

class _EditProductScreenState extends State<EditProductScreen>{

late TextEditingController nameController;
late TextEditingController priceController;
late TextEditingController descriptionController;

bool loading=false;

@override
void initState(){

super.initState();

nameController=
TextEditingController(text:widget.product.name);

priceController=
TextEditingController(text:widget.product.price.toString());

descriptionController=
TextEditingController(text:widget.product.description);

}
Future<void> updateProduct() async{

  if(nameController.text.trim().isEmpty ||
      priceController.text.trim().isEmpty ||
      descriptionController.text.trim().isEmpty){
    return;
  }

  setState(()=>loading=true);

  try{

    await ProductService.updateProduct(

      id:widget.product.id!,

      name:nameController.text.trim(),

      price:double.parse(
        priceController.text.trim(),
      ),

      description:descriptionController.text.trim(),

      categoryId:widget.product.categoryId,

    );

    if(!mounted)return;

    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(
        content:Text("Product Updated Successfully"),
      ),

    );

    Navigator.pop(context,true);

  }catch(e){

    if(!mounted)return;

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

    backgroundColor:AppColors.background,

    appBar:AppBar(
      title:const Text("Edit Product"),
    ),

    body:SingleChildScrollView(

      padding:const EdgeInsets.all(20),

      child:Column(

        children:[

          TextField(
            controller:nameController,
            decoration:const InputDecoration(
              labelText:"Product Name",
            ),
          ),

          const SizedBox(height:15),

          TextField(
            controller:priceController,
            keyboardType:TextInputType.number,
            decoration:const InputDecoration(
              labelText:"Price",
            ),
          ),

          const SizedBox(height:15),

          TextField(
            controller:descriptionController,
            maxLines:4,
            decoration:const InputDecoration(
              labelText:"Description",
            ),
          ),

          const SizedBox(height:25),

          SizedBox(

            width:double.infinity,
            height:55,

            child:ElevatedButton(

              onPressed:loading?null:updateProduct,

              child:loading
                  ?const CircularProgressIndicator(
                color:Colors.white,
              )
                  :const Text("Update Product"),

            ),

          ),

        ],

      ),

    ),

  );

}

@override
void dispose(){

  nameController.dispose();
  priceController.dispose();
  descriptionController.dispose();

  super.dispose();

}

}