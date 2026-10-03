import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/resident.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _apartmentController;
  late TextEditingController _blockController;
  late TextEditingController _phoneController;
  late TextEditingController _emergencyController;
  late TextEditingController _notesController;

  Resident? _resident;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _apartmentController = TextEditingController();
    _blockController = TextEditingController();
    _phoneController = TextEditingController();
    _emergencyController = TextEditingController();
    _notesController = TextEditingController();
    _loadResidentProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _apartmentController.dispose();
    _blockController.dispose();
    _phoneController.dispose();
    _emergencyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadResidentProfile() async {
    setState(() => _isLoading = true);
    final res = await DatabaseHelper.instance.getResident();
    if (res != null && mounted) {
      setState(() {
        _resident = res;
        _nameController.text = res.name;
        _apartmentController.text = res.apartmentNumber;
        _blockController.text = res.buildingBlock;
        _phoneController.text = res.phoneNumber;
        _emergencyController.text = res.emergencyContact;
        _notesController.text = res.notes;
        _isLoading = false;
      });
    } else if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final updated = Resident(
      id: _resident?.id,
      name: _nameController.text.trim(),
      apartmentNumber: _apartmentController.text.trim(),
      buildingBlock: _blockController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      emergencyContact: _emergencyController.text.trim(),
      notes: _notesController.text.trim(),
    );

    await DatabaseHelper.instance.saveResident(updated);

    if (mounted) {
      setState(() {
        _resident = updated;
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved successfully!'), backgroundColor: AppTheme.success),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resident Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 32,
                            backgroundColor: AppTheme.accent,
                            child: Text(
                              _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : 'R',
                              style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _nameController.text.isNotEmpty ? _nameController.text : 'Resident Name',
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${_apartmentController.text} • ${_blockController.text}',
                                  style: const TextStyle(fontSize: 14, color: AppTheme.secondaryBackground),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Personal & Apartment Info',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primary),
                    ),
                    const SizedBox(height: 12),

                    // Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Resident Full Name *',
                        prefixIcon: Icon(Icons.person, color: AppTheme.primary),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),

                    // Apt Number & Block
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _apartmentController,
                            decoration: const InputDecoration(
                              labelText: 'Apartment No. *',
                              prefixIcon: Icon(Icons.home, color: AppTheme.primary),
                            ),
                            validator: (val) => (val == null || val.trim().isEmpty) ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            controller: _blockController,
                            decoration: const InputDecoration(
                              labelText: 'Building / Block *',
                              prefixIcon: Icon(Icons.domain, color: AppTheme.primary),
                            ),
                            validator: (val) => (val == null || val.trim().isEmpty) ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Phone Number
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone, color: AppTheme.primary),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Emergency Contact
                    TextFormField(
                      controller: _emergencyController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Emergency Contact Number',
                        prefixIcon: Icon(Icons.emergency, color: AppTheme.primary),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Notes
                    TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Gate Instructions / Resident Notes',
                        prefixIcon: Icon(Icons.note_alt_outlined, color: AppTheme.primary),
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _isSaving ? null : _saveProfile,
                        icon: _isSaving
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Icon(Icons.save_rounded),
                        label: const Text('Save Resident Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
