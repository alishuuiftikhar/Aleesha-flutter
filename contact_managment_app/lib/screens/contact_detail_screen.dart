import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../database/database_helper.dart';
import '../models/contact_model.dart';
import '../theme/app_theme.dart';
import 'add_edit_contact_screen.dart';

class ContactDetailScreen extends StatefulWidget {
  final ContactModel contact;

  const ContactDetailScreen({super.key, required this.contact});

  @override
  State<ContactDetailScreen> createState() => _ContactDetailScreenState();
}

class _ContactDetailScreenState extends State<ContactDetailScreen> {
  late ContactModel _contact;

  @override
  void initState() {
    super.initState();
    _contact = widget.contact;
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      _showErrorSnackBar('Could not launch phone app');
    }
  }

  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      _showErrorSnackBar('Could not launch email app');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _toggleFavorite() async {
    final updatedContact = _contact.copyWith(isFavorite: _contact.isFavorite == 1 ? 0 : 1);
    await DatabaseHelper.instance.updateContact(updatedContact);
    setState(() {
      _contact = updatedContact;
    });
  }

  Future<void> _deleteContact() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: const Text('Are you sure you want to delete this contact?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DatabaseHelper.instance.deleteContact(_contact.id!);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(_contact.isFavorite == 1 ? Icons.favorite : Icons.favorite_border),
            color: _contact.isFavorite == 1 ? AppTheme.coralPink : null,
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddEditContactScreen(contact: _contact),
                ),
              );
              final updatedContact = await DatabaseHelper.instance.readContact(_contact.id!);
              if (updatedContact != null) {
                setState(() {
                  _contact = updatedContact;
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteContact,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              color: Colors.white,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: AppTheme.coralPink.withOpacity(0.1),
                    child: Text(
                      _contact.name.isNotEmpty ? _contact.name[0].toUpperCase() : '?',
                      style: const TextStyle(fontSize: 48, color: AppTheme.plum, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _contact.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.plum),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailTile(
              icon: Icons.phone_outlined,
              title: 'Phone',
              value: _contact.phoneNumber,
              onTap: () => _makePhoneCall(_contact.phoneNumber),
            ),
            if (_contact.email != null && _contact.email!.isNotEmpty)
              _buildDetailTile(
                icon: Icons.email_outlined,
                title: 'Email',
                value: _contact.email!,
                onTap: () => _sendEmail(_contact.email!),
              ),
            if (_contact.address != null && _contact.address!.isNotEmpty)
              _buildDetailTile(
                icon: Icons.location_on_outlined,
                title: 'Address',
                value: _contact.address!,
              ),
            if (_contact.notes != null && _contact.notes!.isNotEmpty)
              _buildDetailTile(
                icon: Icons.notes,
                title: 'Notes',
                value: _contact.notes!,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTile({required IconData icon, required String title, required String value, VoidCallback? onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.coralPink),
        title: Text(title, style: const TextStyle(fontSize: 12, color: AppTheme.textGrey)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16, color: Colors.black87)),
        onTap: onTap,
        trailing: onTap != null ? const Icon(Icons.open_in_new, size: 16, color: AppTheme.textGrey) : null,
      ),
    );
  }
}
