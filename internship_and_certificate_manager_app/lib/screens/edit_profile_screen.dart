import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/student_model.dart';
import '../services/app_provider.dart';
import '../utils/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _univController;
  late TextEditingController _degreeController;
  late TextEditingController _semController;
  late TextEditingController _skillsController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  
  String? _profileImage;

  @override
  void initState() {
    super.initState();
    final student = Provider.of<AppProvider>(context, listen: false).student;
    
    _nameController = TextEditingController(text: student?.name);
    _univController = TextEditingController(text: student?.university);
    _degreeController = TextEditingController(text: student?.degree);
    _semController = TextEditingController(text: student?.semester);
    _skillsController = TextEditingController(text: student?.skills);
    _emailController = TextEditingController(text: student?.email);
    _phoneController = TextEditingController(text: student?.phone);
    _profileImage = student?.profileImage;
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _profileImage = picked.path);
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<AppProvider>(context, listen: false);
      final student = Student(
        id: provider.student?.id,
        name: _nameController.text,
        university: _univController.text,
        degree: _degreeController.text,
        semester: _semController.text,
        skills: _skillsController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        profileImage: _profileImage,
      );
      
      provider.saveStudent(student);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildImagePicker(),
              const SizedBox(height: 32),
              _buildField(_nameController, 'Full Name', Icons.person),
              _buildField(_univController, 'University', Icons.school),
              _buildField(_degreeController, 'Degree', Icons.history_edu),
              _buildField(_semController, 'Semester', Icons.calendar_view_day),
              _buildField(_emailController, 'Email', Icons.email_outlined),
              _buildField(_phoneController, 'Phone', Icons.phone_outlined),
              _buildField(_skillsController, 'Skills (comma separated)', Icons.star_border, maxLines: 2),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: AppColors.cardBackground,
          backgroundImage: _profileImage != null ? FileImage(File(_profileImage!)) : null,
          child: _profileImage == null ? const Icon(Icons.person, size: 60, color: AppColors.primary) : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _pickImage,
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: AppColors.secondaryText),
        ),
        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
      ),
    );
  }
}
