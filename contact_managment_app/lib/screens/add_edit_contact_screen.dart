import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/contact_model.dart';
import '../models/group_model.dart';
import '../theme/app_theme.dart';

class AddEditContactScreen extends StatefulWidget {
  final ContactModel? contact;

  const AddEditContactScreen({super.key, this.contact});

  @override
  State<AddEditContactScreen> createState() => _AddEditContactScreenState();
}

class _AddEditContactScreenState extends State<AddEditContactScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _phoneNumber;
  String? _email;
  String? _address;
  String? _notes;
  int _isFavorite = 0;
  int? _groupId;
  List<GroupModel> _groups = [];

  @override
  void initState() {
    super.initState();
    _name = widget.contact?.name ?? '';
    _phoneNumber = widget.contact?.phoneNumber ?? '';
    _email = widget.contact?.email;
    _address = widget.contact?.address;
    _notes = widget.contact?.notes;
    _isFavorite = widget.contact?.isFavorite ?? 0;
    _groupId = widget.contact?.groupId;
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    final groups = await DatabaseHelper.instance.readAllGroups();
    setState(() {
      _groups = groups;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.contact != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Contact' : 'Add Contact'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveContact,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: AppTheme.softGrey,
                  child: Icon(Icons.person, size: 50, color: AppTheme.plum),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person_outlined),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a name' : null,
                onSaved: (value) => _name = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _phoneNumber,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty ? 'Please enter a phone number' : null,
                onSaved: (value) => _phoneNumber = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) => _email = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _address,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                onSaved: (value) => _address = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _notes,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  prefixIcon: Icon(Icons.notes),
                ),
                maxLines: 3,
                onSaved: (value) => _notes = value,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _groupId,
                decoration: const InputDecoration(
                  labelText: 'Group',
                  prefixIcon: Icon(Icons.group_work_outlined),
                ),
                items: [
                  const DropdownMenuItem<int>(
                    value: null,
                    child: Text('No Group'),
                  ),
                  ..._groups.map((group) {
                    return DropdownMenuItem<int>(
                      value: group.id,
                      child: Text(group.name),
                    );
                  }).toList(),
                ],
                onChanged: (value) {
                  setState(() => _groupId = value);
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Add to Favorites'),
                value: _isFavorite == 1,
                activeColor: AppTheme.coralPink,
                onChanged: (value) {
                  setState(() => _isFavorite = value ? 1 : 0);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveContact() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final contact = ContactModel(
        id: widget.contact?.id,
        name: _name,
        phoneNumber: _phoneNumber,
        email: _email,
        address: _address,
        notes: _notes,
        isFavorite: _isFavorite,
        groupId: _groupId,
      );

      if (widget.contact == null) {
        await DatabaseHelper.instance.createContact(contact);
      } else {
        await DatabaseHelper.instance.updateContact(contact);
      }

      if (mounted) {
        Navigator.pop(context);
      }
    }
  }
}
