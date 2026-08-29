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
    final user = Supabase.instance.client.auth.currentUser;
    if(user!=null){
      try {
        final data = await ProfileService.getProfile(user.id);
        if (mounted && data != null) {
          setState(() {
            nameController.text = data['full_name'] ?? "";
            phoneController.text = data['phone'] ?? "";
            addressController.text = data['address'] ?? "";
          });
        }
      } catch (e) {
        debugPrint("Error loading profile: $e");
      }
    }
  }



  Future<void> updateProfile() async{
    final user = Supabase.instance.client.auth.currentUser;
    if(user==null) {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User not logged in")));
       return;
    }

    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Name cannot be empty")));
      return;
    }

    setState(() => loading = true);

    try {
      debugPrint("Starting profile update...");
      await ProfileService.updateProfile(
        userId: user.id,
        fullName: nameController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
        email: user.email, // Save email as well
      );
      
      debugPrint("Update successful");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile Updated Successfully"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint("Update catch error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Masla aa gaya: ${e.toString()}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }



  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextField(
              controller: nameController,
              hintText: "Full Name",
              prefixIcon: Icons.person,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: phoneController,
              hintText: "Phone",
              prefixIcon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 15),
            CustomTextField(
              controller: addressController,
              hintText: "Address",
              prefixIcon: Icons.location_on,
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: "Save Changes",
              isLoading: loading,
              onPressed: updateProfile,
            ),
            if (loading) ...[
              const SizedBox(height: 10),
              const Text("Saving... Please wait", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ]
          ],
        ),
      ),
    );
  }
}
