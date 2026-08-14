import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MedicineScreen extends StatefulWidget{
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState()=>_MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen>{

  final supabase=Supabase.instance.client;

  List medicines=[];
  List filtered=[];

  final search=TextEditingController();
  final name=TextEditingController();
  final quantity=TextEditingController();
  final price=TextEditingController();

  final pink=const Color(0xFFEC4899);

  @override
  void initState(){
    super.initState();
    fetchMedicine();
  }

  Future<void> fetchMedicine()async{
    final data=await supabase.from('medicines').select();

    setState((){
      medicines=data;
      filtered=data;
    });
  }

  void searchMedicine(String v){
    setState((){
      filtered=medicines.where((m)=>
          m['name'].toString().toLowerCase()
              .contains(v.toLowerCase())).toList();
    });
  }

  Future<void> addMedicine()async{

    if(name.text.isEmpty)return;

    await supabase.from('medicines').insert({
      'name':name.text,
      'quantity':quantity.text,
      'price':price.text,
    });

    name.clear();
    quantity.clear();
    price.clear();

    fetchMedicine();
  }

  Future<void> deleteMedicine(int id)async{
    await supabase.from('medicines')
        .delete()
        .eq('id',id);

    fetchMedicine();
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor:Colors.white,

      appBar:AppBar(
        title:const Text("Medicines"),
        centerTitle:true,
        backgroundColor:pink,
        foregroundColor:Colors.white,
      ),

      body:Padding(
        padding:const EdgeInsets.all(12),

        child:Column(
          children:[

            TextField(
              controller:search,
              onChanged:searchMedicine,
              decoration:input("Search Medicine",Icons.search),
            ),

            const SizedBox(height:8),

            TextField(
              controller:name,
              decoration:input("Medicine Name",Icons.medication),
            ),

            const SizedBox(height:8),

            TextField(
              controller:quantity,
              decoration:input("Quantity",Icons.inventory),
            ),

            const SizedBox(height:8),

            TextField(
              controller:price,
              decoration:input("Price",Icons.attach_money),
            ),

            const SizedBox(height:10),

            SizedBox(
              width:double.infinity,
              height:50,

              child:ElevatedButton.icon(
                onPressed:addMedicine,
                icon:const Icon(Icons.add),
                label:const Text("Add Medicine"),

                style:ElevatedButton.styleFrom(
                  backgroundColor:pink,
                  foregroundColor:Colors.white,
                  shape:RoundedRectangleBorder(
                    borderRadius:BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            const SizedBox(height:10),

            Expanded(
              child:ListView.builder(
                itemCount:filtered.length,

                itemBuilder:(context,index){

                  final m=filtered[index];

                  return Card(
                    elevation:3,

                    shape:RoundedRectangleBorder(
                      borderRadius:BorderRadius.circular(15),
                    ),

                    child:ListTile(

                      leading:CircleAvatar(
                        backgroundColor:pink,
                        child:const Icon(
                          Icons.medication,
                          color:Colors.white,
                        ),
                      ),

                      title:Text(
                        m['name'],
                        style:const TextStyle(
                          fontWeight:FontWeight.bold,
                        ),
                      ),

                      subtitle:Text(
                        "Quantity: ${m['quantity']}\nPrice: ${m['price']}",
                      ),

                      trailing:IconButton(
                        icon:const Icon(
                          Icons.delete,
                          color:Colors.red,
                        ),

                        onPressed:(){
                          deleteMedicine(m['id']);
                        },
                      ),

                    ),
                  );

                },
              ),
            ),

          ],
        ),
      ),
    );
  }

  InputDecoration input(String text,IconData icon){

    return InputDecoration(

      labelText:text,

      prefixIcon:Icon(
        icon,
        color:pink,
      ),

      border:OutlineInputBorder(
        borderRadius:BorderRadius.circular(15),
      ),

    );
  }

  @override
  void dispose(){

    search.dispose();
    name.dispose();
    quantity.dispose();
    price.dispose();

    super.dispose();
  }

}