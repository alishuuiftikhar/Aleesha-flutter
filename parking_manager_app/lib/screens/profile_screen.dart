import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBackground,
      appBar: AppBar(
        title: const Text('Admin Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            color: AppColors.primary,
            child: const Column(
              children: [
                CircleAvatar(radius: 50, backgroundColor: AppColors.accent, child: Icon(Icons.person, size: 60, color: Colors.white)),
                SizedBox(height: 15),
                Text('Admin Manager', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                Text('admin@parkpro.com', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _buildInfoItem(Icons.work, 'Role', 'Senior Administrator'),
          _buildInfoItem(Icons.phone, 'Phone', '+1 234 567 890'),
          _buildInfoItem(Icons.location_on, 'Assigned Lot', 'Main Street Plaza'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.secondary),
      title: Text(label, style: const TextStyle(fontSize: 14, color: AppColors.secondary)),
      subtitle: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text)),
    );
  }
}
