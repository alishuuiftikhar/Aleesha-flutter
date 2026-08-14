import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../widgets/contact_action_button.dart';
import 'add_edit_contact_screen.dart';
import '../services/contact_service.dart';

class ContactDetailScreen extends StatelessWidget {
  final Contact contact;
  final ContactService _contactService = ContactService();

  ContactDetailScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text('Contact Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            onPressed: () async {
              final updatedContact = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditContactScreen(contact: contact),
                ),
              );
              if (updatedContact == true) {
                Navigator.pop(context, true);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).primaryColor.withOpacity(0.2),
                        width: 8,
                      ),
                    ),
                    child: Hero(
                      tag: 'avatar-${contact.id}',
                      child: CircleAvatar(
                        radius: 80,
                        backgroundImage: contact.avatarUrl != null
                            ? NetworkImage(contact.avatarUrl!)
                            : null,
                        child: contact.avatarUrl == null
                            ? Text(contact.name[0], style: const TextStyle(fontSize: 60))
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              contact.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              contact.jobTitle,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide(color: Colors.grey.shade100),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: ActionButtonsRow(
                  name: contact.name,
                  phone: contact.phone,
                  email: contact.email,
                  website: contact.website,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Column(
      children: [
        _buildInfoCard(
          context,
          icon: Icons.phone_rounded,
          title: 'Phone',
          value: contact.phone,
          color: Colors.green,
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          context,
          icon: Icons.email_rounded,
          title: 'Email',
          value: contact.email,
          color: Colors.orange,
        ),
        if (contact.website != null && contact.website!.isNotEmpty) ...[
          const SizedBox(height: 16),
          _buildInfoCard(
            context,
            icon: Icons.language_rounded,
            title: 'Website',
            value: contact.website!,
            color: Colors.blue,
          ),
        ],
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context,
      {required IconData icon,
      required String title,
      required String value,
      required Color color}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: const Text('Are you sure you want to delete this contact?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (contact.id != null) {
                await _contactService.deleteContact(contact.id!);
              }
              Navigator.pop(context); // Close dialog
              Navigator.pop(context, true); // Return to home
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
