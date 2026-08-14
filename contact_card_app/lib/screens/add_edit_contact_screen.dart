import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../services/contact_service.dart';

class AddEditContactScreen extends StatefulWidget {
  final Contact? contact;

  const AddEditContactScreen({super.key, this.contact});

  @override
  State<AddEditContactScreen> createState() => _AddEditContactScreenState();
}

class _AddEditContactScreenState extends State<AddEditContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contactService = ContactService();

  late TextEditingController _nameController;
  late TextEditingController _jobController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _websiteController;
  late TextEditingController _avatarUrlController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name);
    _jobController = TextEditingController(text: widget.contact?.jobTitle);
    _phoneController = TextEditingController(text: widget.contact?.phone);
    _emailController = TextEditingController(text: widget.contact?.email);
    _websiteController = TextEditingController(text: widget.contact?.website);
    _avatarUrlController = TextEditingController(text: widget.contact?.avatarUrl);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _jobController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _websiteController.dispose();
    _avatarUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final contact = Contact(
      id: widget.contact?.id,
      name: _nameController.text,
      jobTitle: _jobController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      website: _websiteController.text,
      avatarUrl: _avatarUrlController.text.isNotEmpty ? _avatarUrlController.text : null,
      createdAt: widget.contact?.createdAt,
    );

    try {
      if (widget.contact == null) {
        await _contactService.addContact(contact);
      } else {
        await _contactService.updateContact(contact);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving contact: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact == null ? 'New Contact' : 'Edit Contact'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_nameController, 'Full Name', Icons.person_rounded),
              const SizedBox(height: 16),
              _buildTextField(_jobController, 'Job Title', Icons.work_rounded),
              const SizedBox(height: 16),
              _buildTextField(_phoneController, 'Phone Number', Icons.phone_rounded, keyboardType: TextInputType.phone),
              const SizedBox(height: 16),
              _buildTextField(_emailController, 'Email Address', Icons.email_rounded, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              _buildTextField(_websiteController, 'Website (Optional)', Icons.language_rounded),
              const SizedBox(height: 16),
              _buildTextField(_avatarUrlController, 'Avatar URL (Optional)', Icons.image_rounded),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveContact,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.contact == null ? 'Create Contact' : 'Save Changes',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (label.contains('Optional')) return null;
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
