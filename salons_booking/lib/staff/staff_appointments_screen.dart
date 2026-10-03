import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StaffAppointmentsScreen extends StatelessWidget {
  const StaffAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Beauty Sessions'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return _buildSessionCard(context, index);
        },
      ),
    );
  }

  Widget _buildSessionCard(BuildContext context, int index) {
    final status = index == 0 ? 'Pending' : (index == 1 ? 'Confirmed' : 'Completed');
    final statusColor = status == 'Pending' ? Colors.orange : (status == 'Confirmed' ? Colors.green : Colors.grey);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Hydrating Facial', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.deepRose)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              Icon(Icons.person_outline, size: 16, color: Colors.grey),
              SizedBox(width: 8),
              Text('Jane Doe', style: TextStyle(color: Colors.grey)),
              Spacer(),
              Icon(Icons.access_time, size: 16, color: Colors.grey),
              SizedBox(width: 4),
              Text('10:00 AM', style: TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 20),
          if (status == 'Pending')
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.redAccent), foregroundColor: Colors.redAccent),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text('Accept'),
                  ),
                ),
              ],
            )
          else if (status == 'Confirmed')
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Mark Completed'),
              ),
            ),
        ],
      ),
    );
  }
}
