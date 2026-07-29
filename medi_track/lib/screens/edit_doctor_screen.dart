import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditDoctorScreen extends StatefulWidget{

  final Map doctor;

  const EditDoctorScreen({
    super.key,
    required this.doctor,
  });


  @override
  State<EditDoctorScreen> createState()=>_EditDoctorScreenState();

}


class _EditDoctorScreenState extends State<EditDoctorScreen>{


  final supabase=Supabase.instance.client;


  late TextEditingController name;
  late TextEditingController speciality;
  late TextEditingController phone;



  @override
  void initState(){

    super.initState();

    name=TextEditingController(
      text:widget.doctor['name'],
    );

    speciality=TextEditingController(
      text:widget.doctor['speciality'],
    );

    phone=TextEditingController(
      text:widget.doctor['phone'],
    );

  }



  Future<void> updateDoctor()async{


    if(name.text.isEmpty ||
        speciality.text.isEmpty ||
        phone.text.isEmpty){

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content:
          Text("Please fill all fields"),
        ),

      );

      return;

    }


    await supabase
        .from('doctors')
        .update({

      'name':name.text.trim(),

      'speciality':
      speciality.text.trim(),

      'phone':
      phone.text.trim(),

    })
        .eq(
      'id',
      widget.doctor['id'],
    );



    if(!mounted)return;


    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(
        content:
        Text("Doctor Updated Successfully"),
      ),

    );



    Navigator.pop(context);


  }



  @override
  Widget build(BuildContext context){

    return Scaffold(

      appBar:AppBar(

        title:
        const Text("Edit Doctor"),

        centerTitle:true,

        backgroundColor:
        const Color(0xFFEC4899),

        foregroundColor:
        Colors.white,

      ),



      body:Padding(

        padding:
        const EdgeInsets.all(15),


        child:Column(

          children:[


            field(
              name,
              "Doctor Name",
              Icons.person,
            ),


            const SizedBox(height:12),



            field(
              speciality,
              "Speciality",
              Icons.medical_services,
            ),


            const SizedBox(height:12),



            field(
              phone,
              "Phone",
              Icons.phone,
            ),



            const SizedBox(height:25),



            SizedBox(

              width:
              double.infinity,

              height:
              55,


              child:
              ElevatedButton(

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  const Color(0xFFEC4899),

                  foregroundColor:
                  Colors.white,

                  shape:
                  RoundedRectangleBorder(

                    borderRadius:
                    BorderRadius.circular(15),

                  ),

                ),


                onPressed:
                updateDoctor,


                child:
                const Text(

                  "Update Doctor",

                  style:
                  TextStyle(
                    fontSize:17,
                    fontWeight:
                    FontWeight.bold,
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
      TextEditingController c,
      String text,
      IconData icon,
      ){

    return TextField(

      controller:c,


      decoration:
      InputDecoration(

        labelText:text,


        prefixIcon:
        Icon(
          icon,
          color:
          const Color(0xFFEC4899),
        ),


        filled:true,

        fillColor:
        Colors.white,


        border:
        OutlineInputBorder(

          borderRadius:
          BorderRadius.circular(15),

          borderSide:
          BorderSide.none,

        ),

      ),

    );

  }



  @override
  void dispose(){

    name.dispose();
    speciality.dispose();
    phone.dispose();

    super.dispose();

  }


}