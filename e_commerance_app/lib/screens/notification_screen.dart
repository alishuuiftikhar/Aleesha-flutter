import 'package:flutter/material.dart';
import '../theme/app_colors.dart';


class NotificationsScreen extends StatelessWidget {


  const NotificationsScreen({super.key});



  @override
  Widget build(BuildContext context) {


    return Scaffold(


      backgroundColor:
      AppColors.background,



      appBar: AppBar(


        backgroundColor:
        AppColors.primary,


        title:
        const Text(
          "Notifications",
        ),


        centerTitle:true,


      ),



      body: const Center(


        child: Column(


          mainAxisAlignment:
          MainAxisAlignment.center,



          children:[



            Icon(

              Icons.notifications_none,

              size:80,

            ),



            SizedBox(height:15),



            Text(

              "No Notifications",

              style:
              TextStyle(

                fontSize:18,

                fontWeight:
                FontWeight.w600,

              ),

            ),



          ],


        ),


      ),



    );


  }


}