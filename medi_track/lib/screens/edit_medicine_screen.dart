import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditMedicineScreen extends StatefulWidget{

  final Map medicine;

  const EditMedicineScreen({
    super.key,
    required this.medicine,
  });

  @override
  State<EditMedicineScreen> createState()=>_EditMedicineScreenState();
}

class _EditMedicineScreenState extends State<EditMedicineScreen>{

  final supabase=Supabase.instance.client;

  late TextEditingController name;
  late TextEditingController quantity;
  late TextEditingController price;

  final pink=const Color(0xFFEC4899);

  @override
  void initState(){
    super.initState();

    name=TextEditingController(
        text:widget.medicine['name'].toString());

    quantity=TextEditingController(
        text:widget.medicine['quantity'].toString());

    price=TextEditingController(
        text:widget.medicine['price'].toString());

  }

  Future<void> updateMedicine()async{

    await supabase.from('medicines').update({

      'name':name.text.trim(),
      'quantity':quantity.text.trim(),
      'price':price.text.trim(),

    }).eq(
      'id',
      widget.medicine['id'],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:Text("Medicine Updated Successfully"),
      ),
    );

    Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor:Colors.white,

      appBar:AppBar(
        title:const Text("Edit Medicine"),
        centerTitle:true,
        backgroundColor:pink,
        foregroundColor:Colors.white,
      ),

      body:Padding(
        padding:const EdgeInsets.all(15),

        child:Column(
          children:[

            field(name,"Medicine Name",Icons.medication),

            const SizedBox(height:10),

            field(quantity,"Quantity",Icons.inventory),

            const SizedBox(height:10),

            field(price,"Price",Icons.attach_money),

            const SizedBox(height:20),

            SizedBox(
              width:double.infinity,
              height:55,

              child:ElevatedButton(

                onPressed:updateMedicine,

                style:ElevatedButton.styleFrom(
                  backgroundColor:pink,
                  foregroundColor:Colors.white,

                  shape:RoundedRectangleBorder(
                    borderRadius:BorderRadius.circular(15),
                  ),
                ),

                child:const Text(
                  "Update Medicine",
                  style:TextStyle(
                    fontWeight:FontWeight.bold,
                    fontSize:16,
                  ),
                ),

              ),

            ),

          ],
        ),

      ),

    );

  }

  Widget field(
      TextEditingController controller,
      String text,
      IconData icon,
      ){

    return TextField(

      controller:controller,

      decoration:InputDecoration(

        labelText:text,

        prefixIcon:Icon(
          icon,
          color:pink,
        ),

        filled:true,

        fillColor:Colors.white,

        border:OutlineInputBorder(
          borderRadius:BorderRadius.circular(15),
          borderSide:BorderSide.none,
        ),

      ),

    );

  }

  @override
  void dispose(){

    name.dispose();
    quantity.dispose();
    price.dispose();

    super.dispose();

  }

}