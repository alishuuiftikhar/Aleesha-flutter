import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class ContactActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const ContactActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

class ActionButtonsRow extends StatelessWidget {
  final String phone;
  final String email;
  final String? website;
  final String name;

  const ActionButtonsRow({
    super.key,
    required this.phone,
    required this.email,
    this.website,
    required this.name,
  });

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ContactActionButton(
          icon: Icons.call_rounded,
          label: 'Call',
          color: Colors.green,
          onTap: () => _launchUrl('tel:$phone'),
        ),
        ContactActionButton(
          icon: Icons.message_rounded,
          label: 'Message',
          color: Colors.blue,
          onTap: () => _launchUrl('sms:$phone'),
        ),
        ContactActionButton(
          icon: Icons.email_rounded,
          label: 'Email',
          color: Colors.orange,
          onTap: () => _launchUrl('mailto:$email'),
        ),
        ContactActionButton(
          icon: Icons.share_rounded,
          label: 'Share',
          color: Colors.purple,
          onTap: () {
            Share.share('Check out this contact: $name\nPhone: $phone\nEmail: $email');
          },
        ),
      ],
    );
  }
}
