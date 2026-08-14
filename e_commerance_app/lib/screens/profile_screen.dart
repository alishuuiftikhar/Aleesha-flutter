import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_colors.dart';
import '../widgets/loading_widget.dart';
import '../services/profile_service.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState()=>_ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>{

  Map<String,dynamic>? profile;
  bool loading=true;


  @override
  void initState(){
    super.initState();
    loadProfile();
  }


  Future<void> loadProfile() async{

    final user =
        Supabase.instance.client.auth.currentUser;


    if(user!=null){

      final data =
      await ProfileService.getProfile(
        user.id,
      );


      setState((){

        profile=data;
        loading=false;

      });

    }

  }



  Future<void> logout() async{

    await Supabase.instance.client.auth.signOut();


    if(!mounted)return;


    Navigator.pushAndRemoveUntil(

      context,

      MaterialPageRoute(
        builder:(_)=>const LoginScreen(),
      ),

          (route)=>false,

    );

  }



  @override
  Widget build(BuildContext context){

    final user =
        Supabase.instance.client.auth.currentUser;


    return Scaffold(

      backgroundColor:AppColors.background,


      appBar:AppBar(

        backgroundColor:AppColors.primary,

        title:const Text(
          "Profile",
        ),

        centerTitle:true,

      ),



      body:loading

          ? const LoadingWidget()


          :Padding(

        padding:const EdgeInsets.all(20),


        child:Column(

          children:[


            const CircleAvatar(

              radius:45,

              child:Icon(
                Icons.person,
                size:45,
              ),

            ),



            const SizedBox(height:20),



            Text(

              profile?['full_name'] ??
                  "User",

              style:const TextStyle(

                fontSize:22,

                fontWeight:FontWeight.bold,

              ),

            ),



            const SizedBox(height:10),



            Text(

              user?.email ?? "",

            ),



            const SizedBox(height:20),



            Card(

              child:ListTile(

                leading:const Icon(
                  Icons.phone,
                ),

                title:Text(

                  profile?['phone'] ??
                      "No Phone",

                ),

              ),

            ),



            Card(

              child:ListTile(

                leading:const Icon(
                  Icons.location_on,
                ),

                title:Text(

                  profile?['address'] ??
                      "No Address",

                ),

              ),

            ),



            const SizedBox(height:20),



            SizedBox(

              width:double.infinity,

              height:50,


              child:ElevatedButton(

                onPressed:(){


                  Navigator.push(

                    context,

                    MaterialPageRoute(

                      builder:(_)=>
                      const EditProfileScreen(),

                    ),

                  ).then((value){

                    loadProfile();

                  });


                },

                child:const Text(
                  "Edit Profile",
                ),

              ),

            ),



            const SizedBox(height:15),



            SizedBox(

              width:double.infinity,

              height:50,


              child:ElevatedButton(

                onPressed:logout,


                child:const Text(
                  "Logout",
                ),

              ),

            )


          ],

        ),

      ),

    );

  }

}