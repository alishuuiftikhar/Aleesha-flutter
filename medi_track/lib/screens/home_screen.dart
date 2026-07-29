import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'add_patient_screen.dart';
import 'doctor_screen.dart';
import 'appointment_screen.dart';
import 'medicine_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState()=>_HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{

  final supabase=Supabase.instance.client;

  int patients=0,doctors=0,appointments=0,medicines=0;
  String adminName="Admin";
  bool loading=true;

  final pink=const Color(0xFFEC4899);

  @override
  void initState(){
    super.initState();
    getUser();
    getCount();
  }

  void getUser(){

    final user=supabase.auth.currentUser;

    if(user!=null){
      setState((){
        adminName=user.userMetadata?['name']??"Admin";
      });
    }

  }

  Future<void> getCount()async{

    setState((){
      loading=true;
    });

    final p=await supabase.from('patients').select();
    final d=await supabase.from('doctors').select();
    final a=await supabase.from('appointments').select();
    final m=await supabase.from('medicines').select();

    setState((){
      patients=p.length;
      doctors=d.length;
      appointments=a.length;
      medicines=m.length;
      loading=false;
    });

  }


  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor:Colors.white,

      appBar:AppBar(

        title:const Text("MediTrack"),

        centerTitle:true,

        backgroundColor:pink,

        foregroundColor:Colors.white,

        actions:[

          IconButton(
            icon:const Icon(Icons.person),
            onPressed:(){

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:(context)=>const ProfileScreen(),
                ),
              );

            },
          ),

          IconButton(
            icon:const Icon(Icons.logout),
            onPressed:()async{

              await supabase.auth.signOut();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder:(context)=>const LoginScreen(),
                ),
              );

            },
          ),

        ],

      ),


      body:loading?

      const Center(
        child:CircularProgressIndicator(),
      )

          :

      Padding(

        padding:const EdgeInsets.all(15),

        child:Column(

          crossAxisAlignment:CrossAxisAlignment.start,

          children:[


            Text(
              "Welcome $adminName 👋",
              style:const TextStyle(
                fontSize:24,
                fontWeight:FontWeight.bold,
              ),
            ),


            const SizedBox(height:15),


            Row(
              children:[

                statCard(
                  "Patients",
                  patients,
                  Icons.person,
                ),

                statCard(
                  "Doctors",
                  doctors,
                  Icons.medical_services,
                ),

              ],
            ),


            const SizedBox(height:10),


            Row(
              children:[

                statCard(
                  "Appointments",
                  appointments,
                  Icons.calendar_month,
                ),

                statCard(
                  "Medicines",
                  medicines,
                  Icons.medication,
                ),

              ],
            ),


            const SizedBox(height:15),


            Expanded(

              child:GridView.count(

                crossAxisCount:2,

                crossAxisSpacing:10,

                mainAxisSpacing:10,


                children:[

                  dashboardCard(
                    Icons.person,
                    "Patients",
                    const PatientScreen(),
                  ),

                  dashboardCard(
                    Icons.medical_services,
                    "Doctors",
                    const DoctorScreen(),
                  ),

                  dashboardCard(
                    Icons.calendar_month,
                    "Appointments",
                    const AppointmentScreen(),
                  ),

                  dashboardCard(
                    Icons.medication,
                    "Medicines",
                    const MedicineScreen(),
                  ),

                ],

              ),

            ),


          ],

        ),

      ),

    );

  }



  Widget statCard(
      String title,
      int value,
      IconData icon
      ){

    return Expanded(

      child:Card(

        elevation:4,

        shape:RoundedRectangleBorder(
          borderRadius:BorderRadius.circular(18),
        ),

        child:Padding(

          padding:const EdgeInsets.all(15),

          child:Column(

            children:[

              CircleAvatar(

                backgroundColor:
                pink.withOpacity(0.15),

                child:Icon(
                  icon,
                  color:pink,
                ),

              ),


              const SizedBox(height:8),


              Text(
                value.toString(),

                style:TextStyle(
                  fontSize:25,
                  fontWeight:FontWeight.bold,
                  color:pink,
                ),

              ),


              Text(title),

            ],

          ),

        ),

      ),

    );

  }



  Widget dashboardCard(
      IconData icon,
      String title,
      Widget page
      ){

    return Card(

      elevation:5,

      shape:RoundedRectangleBorder(
        borderRadius:BorderRadius.circular(20),
      ),


      child:InkWell(

        borderRadius:BorderRadius.circular(20),

        onTap:(){

          Navigator.push(
            context,
            MaterialPageRoute(
              builder:(context)=>page,
            ),
          ).then((v)=>getCount());

        },


        child:Column(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children:[


            CircleAvatar(

              radius:30,

              backgroundColor:
              pink.withOpacity(0.15),


              child:Icon(

                icon,

                size:35,

                color:pink,

              ),

            ),


            const SizedBox(height:12),


            Text(

              title,

              style:const TextStyle(
                fontWeight:FontWeight.bold,
              ),

            ),

          ],

        ),

      ),

    );

  }

}