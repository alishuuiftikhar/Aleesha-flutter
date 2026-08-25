import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/certificate_model.dart';
import '../services/app_provider.dart';
import '../utils/app_theme.dart';

class AddEditCertificateScreen extends StatefulWidget {
  final Certificate? certificate;

  const AddEditCertificateScreen({super.key, this.certificate});

  @override
  State<AddEditCertificateScreen> createState() => _AddEditCertificateScreenState();
}

class _AddEditCertificateScreenState extends State<AddEditCertificateScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _titleController = TextEditingController();
  final _orgController = TextEditingController();
  final _idController = TextEditingController();
  final _descController = TextEditingController();
  
  String _category = 'Academic';
  String _status = 'Verified';
  DateTime _issueDate = DateTime.now();
  String? _imagePath;
  
  final List<String> _categories = ['Academic', 'Professional', 'Workshop', 'Other'];
  final List<String> _statusOptions = ['Verified', 'Pending', 'Expired'];

  @override
  void initState() {
    super.initState();
    if (widget.certificate != null) {
      final c = widget.certificate!;
      _titleController.text = c.title;
      _orgController.text = c.organization;
      _idController.text = c.certificateId ?? '';
      _descController.text = c.description ?? '';
      _category = c.category;
      _status = c.status;
      _issueDate = c.issueDate;
      _imagePath = c.imagePath;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imagePath = pickedFile.path);
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _issueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _issueDate = picked);
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final cert = Certificate(
        id: widget.certificate?.id,
        title: _titleController.text,
        organization: _orgController.text,
        issueDate: _issueDate,
        certificateId: _idController.text,
        category: _category,
        description: _descController.text,
        imagePath: _imagePath,
        status: _status,
        isFavorite: widget.certificate?.isFavorite ?? false,
      );

      final provider = Provider.of<AppProvider>(context, listen: false);
      if (widget.certificate == null) {
        provider.addCertificate(cert);
      } else {
        provider.updateCertificate(cert);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.certificate == null ? 'Add Certificate' : 'Edit Certificate'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePicker(),
              const SizedBox(height: 32),
              _buildTextField(_titleController, 'Title', Icons.title, 'e.g. Android Development'),
              _buildTextField(_orgController, 'Organization', Icons.business, 'e.g. Google'),
              _buildTextField(_idController, 'Certificate ID', Icons.fingerprint, 'e.g. CERT-12345'),
              _buildTextField(_descController, 'Description', Icons.description, 'Optional', maxLines: 3),
              const SizedBox(height: 16),
              _buildCategoryPicker(),
              const SizedBox(height: 16),
              _buildStatusPicker(),
              const SizedBox(height: 16),
              _buildDatePicker(),
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
                  child: const Text('Save Certificate', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Container(
          height: 180,
          width: 280,
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withOpacity(0.5), style: BorderStyle.solid),
          ),
          child: _imagePath != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(File(_imagePath!), fit: BoxFit.cover),
                )
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, size: 48, color: AppColors.primary),
                    SizedBox(height: 12),
                    Text('Upload Certificate Image', style: TextStyle(color: AppColors.secondaryText)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, String hint, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColors.secondaryText),
        ),
        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _buildCategoryPicker() {
    return DropdownButtonFormField<String>(
      value: _category,
      decoration: const InputDecoration(labelText: 'Category', prefixIcon: Icon(Icons.category, color: AppColors.secondaryText)),
      items: _categories.map((c) => DropdownMenuItem<String>(value: c, child: Text(c))).toList(),
      onChanged: (val) => setState(() => _category = val!),
    );
  }

  Widget _buildStatusPicker() {
    return DropdownButtonFormField<String>(
      value: _status,
      decoration: const InputDecoration(labelText: 'Status', prefixIcon: Icon(Icons.verified, color: AppColors.secondaryText)),
      items: _statusOptions.map((s) => DropdownMenuItem<String>(value: s, child: Text(s))).toList(),
      onChanged: (val) => setState(() => _status = val!),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: _selectDate,
      child: InputDecorator(
        decoration: const InputDecoration(labelText: 'Issue Date', prefixIcon: Icon(Icons.calendar_today, color: AppColors.secondaryText)),
        child: Text(DateFormat('MMM dd, yyyy').format(_issueDate)),
      ),
    );
  }
}
