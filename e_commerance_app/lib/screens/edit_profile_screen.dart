import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';
import '../services/profile_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState()=>_EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>{

  final nameController=TextEditingController();
  final phoneController=TextEditingController();
  final addressController=TextEditingController();

  bool loading=false;


  @override
  void initState(){
    super.initState();
    loadData();
  }


  Future<void> loadData() async{

    final user =
        Supabase.instance.client.auth.currentUser;


    if(user!=null){

      final data =
      await ProfileService.getProfile(
        user.id,
      );


      nameController.text =
          data?['full_name'] ?? "";


      phoneController.text =
          data?['phone'] ?? "";


      addressController.text =
          data?['address'] ?? "";

    }

  }



  Future<void> updateProfile() async{

    final user =
        Supabase.instance.client.auth.currentUser;


    if(user==null)return;


    setState((){

      loading=true;

    });


    await ProfileService.updateProfile(

      userId:user.id,

      fullName:nameController.text.trim(),

      phone:phoneController.text.trim(),

      address:addressController.text.trim(),

    );



    if(!mounted)return;


    ScaffoldMessenger.of(context).showSnackBar(

      const SnackBar(

        content:Text(
          "Profile Updated Successfully",
        ),

      ),

    );


    Navigator.pop(context);



    setState((){

      loading=false;

    });

  }



  @override
  Widget build(BuildContext context){

    return Scaffold(

      backgroundColor:AppColors.background,


      appBar:AppBar(

        backgroundColor:AppColors.primary,

        title:const Text(
          "Edit Profile",
        ),

        centerTitle:true,

      ),



      body:Padding(

        padding:const EdgeInsets.all(20),


        child:Column(

          children:[


            CustomTextField(

              controller:nameController,

              hintText:"Full Name",

              prefixIcon:Icons.person,

            ),


            const SizedBox(height:15),


            CustomTextField(

              controller:phoneController,

              hintText:"Phone",

              prefixIcon:Icons.phone,

              keyboardType:TextInputType.phone,

            ),


            const SizedBox(height:15),


            CustomTextField(

              controller:addressController,

              hintText:"Address",

              prefixIcon:Icons.location_on,

            ),



            const SizedBox(height:25),



            CustomButton(

              text:"Save Changes",

              isLoading:loading,

              onPressed:updateProfile,

            )


          ],

        ),

      ),

    );

  }

}