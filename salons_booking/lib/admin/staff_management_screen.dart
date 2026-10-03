import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StaffManagementScreen extends StatelessWidget {
  const StaffManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddStaffDialog(context),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: 4,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return _buildStaffTile(context, index);
        },
      ),
    );
  }

  Widget _buildStaffTile(BuildContext context, int index) {
    final names = ['Sarah Johnson', 'Emma Wilson', 'Ayesha Khan', 'Jessica Lee'];
    final roles = ['Hair Stylist', 'Makeup Artist', 'Skin Expert', 'Nail Artist'];
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1594744803329-e58b31de2177?auto=format&fit=crop&q=80&w=2574'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(names[index], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(roles[index], style: TextStyle(color: Colors.grey[600], fontSize: 14)),
              ],
            ),
          ),
          Column(
            children: [
              Switch(
                value: true,
                activeColor: AppTheme.primaryRosePink,
                onChanged: (val) {},
              ),
              const Text('Active', style: TextStyle(fontSize: 10, color: Colors.green)),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  void _showAddStaffDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Beauty Expert'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(decoration: InputDecoration(labelText: 'Full Name')),
              const TextField(decoration: InputDecoration(labelText: 'Email')),
              const TextField(decoration: InputDecoration(labelText: 'Specialization')),
              const TextField(decoration: InputDecoration(labelText: 'Experience (Years)')),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Add Expert ✨'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
