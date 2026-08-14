import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=200'),
            ),
            const SizedBox(height: 15),
            const Text(
              'John Doe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'john.doe@example.com',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            _ProfileItem(icon: Icons.person_outline, title: 'My Account', onTap: () {}),
            _ProfileItem(icon: Icons.shopping_bag_outlined, title: 'My Orders', onTap: () {}),
            _ProfileItem(icon: Icons.location_on_outlined, title: 'Delivery Address', onTap: () {}),
            _ProfileItem(icon: Icons.payment_outlined, title: 'Payment Methods', onTap: () {}),
            _ProfileItem(icon: Icons.notifications_none_outlined, title: 'Notifications', onTap: () {}),
            const SizedBox(height: 20),
            _ProfileItem(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () {},
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? color;

  const _ProfileItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppTheme.accentColor),
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.chevron_right, size: 18),
      onTap: onTap,
    );
  }
}
