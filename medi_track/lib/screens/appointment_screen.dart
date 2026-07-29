import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'edit_appointment_screen.dart';

class AppointmentScreen extends StatefulWidget{
  const AppointmentScreen({super.key});
  @override
  State<AppointmentScreen> createState()=>_AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen>{

  final supabase=Supabase.instance.client;

  List appointments=[];
  List filtered=[];

  final search=TextEditingController();
  final patient=TextEditingController();
  final doctor=TextEditingController();
  final date=TextEditingController();

  String status="Pending";
  final pink=const Color(0xFFEC4899);

  @override
  void initState(){
    super.initState();
    fetchAppointments();
  }

  Future<void> fetchAppointments()async{
    final data=await supabase.from('appointments')
        .select().order('id',ascending:false);

    setState((){
      appointments=data;
      filtered=data;
    });
  }

  void searchAppointment(String value){
    setState((){
      filtered=appointments.where((a)=>
          a['patient_name'].toString().toLowerCase()
              .contains(value.toLowerCase())).toList();
    });
  }

  Future<void> addAppointment()async{

    if(patient.text.isEmpty||doctor.text.isEmpty||date.text.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content:Text("Please fill all fields")));
      return;
    }

    await supabase.from('appointments').insert({
      'patient_name':patient.text.trim(),
      'doctor_name':doctor.text.trim(),
      'appointment_date':date.text.trim(),
      'status':status,
    });

    patient.clear();
    doctor.clear();
    date.clear();

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content:Text("Appointment Added Successfully")));

    fetchAppointments();
  }

  Future<void> deleteAppointment(int id)async{

    await supabase.from('appointments')
        .delete().eq('id',id);

    fetchAppointments();
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
      backgroundColor:Colors.white,

      appBar:AppBar(
        title:const Text("Appointments"),
        centerTitle:true,
        backgroundColor:pink,
        foregroundColor:Colors.white,
      ),

      body:Padding(
        padding:const EdgeInsets.all(15),

        child:Column(
          children:[

            TextField(
              controller:search,
              onChanged:searchAppointment,
              decoration:input("Search Patient",Icons.search),
            ),

            const SizedBox(height:10),

            TextField(
              controller:patient,
              decoration:input("Patient Name",Icons.person),
            ),

            const SizedBox(height:10),

            TextField(
              controller:doctor,
              decoration:input("Doctor Name",Icons.medical_services),
            ),

            const SizedBox(height:10),

            TextField(
              controller:date,
              decoration:input("Appointment Date",Icons.calendar_month),
            ),

            const SizedBox(height:10),

            DropdownButtonFormField(
              value:status,
              decoration:input("Status",Icons.info),

              items:["Pending","Completed"].map((e)=>
                  DropdownMenuItem(
                    value:e,
                    child:Text(e),
                  )).toList(),

              onChanged:(v){
                setState((){
                  status=v.toString();
                });
              },
            ),

            const SizedBox(height:15),

            SizedBox(
              width:double.infinity,
              height:55,

              child:ElevatedButton.icon(
                onPressed:addAppointment,
                icon:const Icon(Icons.add),
                label:const Text("Add Appointment"),

                style:ElevatedButton.styleFrom(
                  backgroundColor:pink,
                  foregroundColor:Colors.white,
                  shape:RoundedRectangleBorder(
                    borderRadius:BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            const SizedBox(height:15),

            Expanded(
              child:ListView.builder(
                itemCount:filtered.length,

                itemBuilder:(context,index){

                  final a=filtered[index];

                  return Card(
                    elevation:4,
                    shape:RoundedRectangleBorder(
                      borderRadius:BorderRadius.circular(18),
                    ),

                    child:ListTile(

                      leading:CircleAvatar(
                        backgroundColor:pink,
                        child:const Icon(
                            Icons.calendar_month,
                            color:Colors.white),
                      ),

                      title:Text(
                        a['patient_name'],
                        style:const TextStyle(
                            fontWeight:FontWeight.bold),
                      ),

                      subtitle:Text(
                          "Doctor: ${a['doctor_name']}\nDate: ${a['appointment_date']}\nStatus: ${a['status']}"
                      ),

                      trailing:Row(
                        mainAxisSize:MainAxisSize.min,

                        children:[

                          IconButton(
                            icon:Icon(Icons.edit,color:pink),

                            onPressed:(){

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:(context)=>EditAppointmentScreen(
                                      appointment:a),
                                ),
                              ).then((v)=>fetchAppointments());

                            },
                          ),

                          IconButton(
                            icon:const Icon(
                                Icons.delete,
                                color:Colors.red),

                            onPressed:(){
                              deleteAppointment(a['id']);
                            },
                          ),

                        ],
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

      filled:true,

      border:OutlineInputBorder(
        borderRadius:BorderRadius.circular(15),
        borderSide:BorderSide.none,
      ),
    );

  }


  @override
  void dispose(){

    search.dispose();
    patient.dispose();
    doctor.dispose();
    date.dispose();

    super.dispose();
  }

}