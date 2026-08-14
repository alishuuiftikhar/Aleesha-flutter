import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditAppointmentScreen extends StatefulWidget{

  final Map appointment;

  const EditAppointmentScreen({
    super.key,
    required this.appointment,
  });

  @override
  State<EditAppointmentScreen> createState()=>_EditAppointmentScreenState();

}

class _EditAppointmentScreenState extends State<EditAppointmentScreen>{

  final supabase=Supabase.instance.client;

  late TextEditingController date;
  late String status;

  final pink=const Color(0xFFEC4899);


  @override
  void initState(){
    super.initState();

    date=TextEditingController(
      text:widget.appointment['appointment_date'].toString(),
    );

    status=widget.appointment['status']??"Pending";

  }



  Future<void> updateAppointment()async{

    await supabase.from('appointments').update({

      'appointment_date':date.text.trim(),
      'status':status,

    }).eq(
      'id',
      widget.appointment['id'],
    );


    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:Text("Appointment Updated Successfully"),
      ),
    );


    Navigator.pop(context);

  }



  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor:Colors.white,

      appBar:AppBar(

        title:const Text("Edit Appointment"),

        centerTitle:true,

        backgroundColor:pink,

        foregroundColor:Colors.white,

      ),


      body:Padding(

        padding:const EdgeInsets.all(15),

        child:Column(

          children:[


            TextField(

              controller:date,

              decoration:input(
                "Appointment Date",
                Icons.calendar_month,
              ),

            ),


            const SizedBox(height:12),



            DropdownButtonFormField(

              value:status,

              decoration:input(
                "Status",
                Icons.info,
              ),


              items:[

                "Pending",
                "Completed"

              ].map((e)=>

                  DropdownMenuItem(

                    value:e,

                    child:Text(e),

                  )

              ).toList(),



              onChanged:(v){

                setState((){

                  status=v.toString();

                });

              },

            ),



            const SizedBox(height:20),



            SizedBox(

              width:double.infinity,

              height:55,


              child:ElevatedButton(

                onPressed:updateAppointment,


                style:ElevatedButton.styleFrom(

                  backgroundColor:pink,

                  foregroundColor:Colors.white,


                  shape:RoundedRectangleBorder(

                    borderRadius:
                    BorderRadius.circular(15),

                  ),

                ),


                child:const Text(

                  "Update Appointment",

                  style:TextStyle(
                    fontSize:16,
                    fontWeight:FontWeight.bold,
                  ),

                ),

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


      filled:true,


      fillColor:Colors.white,


      border:OutlineInputBorder(

        borderRadius:
        BorderRadius.circular(15),

        borderSide:
        BorderSide.none,

      ),

    );

  }



  @override
  void dispose(){

    date.dispose();

    super.dispose();

  }

}