import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StaffScheduleScreen extends StatelessWidget {
  const StaffScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Work Schedule'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWorkingHours(),
            const SizedBox(height: 32),
            _buildUpcomingLeaves(),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkingHours() {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Weekly Working Hours', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.deepRose)),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 7,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(days[index]),
                trailing: Text(
                  index < 5 ? '10:00 AM - 07:00 PM' : 'Closed',
                  style: TextStyle(
                    color: index < 5 ? Colors.black87 : Colors.redAccent,
                    fontWeight: index < 5 ? FontWeight.w500 : FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingLeaves() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Unavailable Dates / Leaves', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.deepRose)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: const Center(
            child: Text('No leaves scheduled for this month ✨', style: TextStyle(color: Colors.grey)),
          ),
        ),
      ],
    );
  }
}
