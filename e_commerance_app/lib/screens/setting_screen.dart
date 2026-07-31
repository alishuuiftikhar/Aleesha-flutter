import 'package:flutter/material.dart';
import '../theme/app_colors.dart';


class SettingsScreen extends StatelessWidget{


  const SettingsScreen({super.key});



  @override
  Widget build(BuildContext context){


    return Scaffold(


      backgroundColor:
      AppColors.background,



      appBar:AppBar(

        backgroundColor:
        AppColors.primary,

        title:
        const Text(
          "Settings",
        ),

        centerTitle:true,

      ),



      body:ListView(


        padding:
        const EdgeInsets.all(16),



        children:[


          Card(

            child:ListTile(

              leading:
              const Icon(
                Icons.notifications,
              ),

              title:
              const Text(
                "Notifications",
              ),


              trailing:
              Switch(

                value:true,

                onChanged:(value){},

              ),

            ),

          ),



          Card(

            child:ListTile(

              leading:
              const Icon(
                Icons.dark_mode,
              ),


              title:
              const Text(
                "Dark Mode",
              ),


              trailing:
              Switch(

                value:false,

                onChanged:(value){},

              ),

            ),

          ),



          Card(

            child:ListTile(

              leading:
              const Icon(
                Icons.info,
              ),


              title:
              const Text(
                "About App",
              ),


              onTap:(){


                showAboutDialog(

                  context:context,

                  applicationName:
                  "E-Commerce App",

                  applicationVersion:
                  "1.0.0",

                );


              },

            ),

          ),



        ],


      ),


    );


  }


}