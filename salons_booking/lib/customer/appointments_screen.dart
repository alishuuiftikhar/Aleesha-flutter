import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Beauty Journeys'),
          bottom: const TabBar(
            indicatorColor: AppTheme.primaryRosePink,
            labelColor: AppTheme.primaryRosePink,
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Past'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUpcomingList(),
            _buildPastList(),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingList() {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 2,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildAppointmentCard(
          context,
          service: 'Hydrating Glow Facial',
          expert: 'Sarah Johnson',
          date: 'Oct 24, 2023',
          time: '10:00 AM',
          status: 'Confirmed ✨',
          statusColor: Colors.green,
        );
      },
    );
  }

  Widget _buildPastList() {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildAppointmentCard(
          context,
          service: 'Signature Haircut',
          expert: 'Emma Wilson',
          date: 'Sep 12, 2023',
          time: '02:00 PM',
          status: 'Completed',
          statusColor: Colors.grey,
        );
      },
    );
  }

  Widget _buildAppointmentCard(
    BuildContext context, {
    required String service,
    required String expert,
    required String date,
    required String time,
    required String status,
    required Color statusColor,
  }) {
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
              Text(service, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.deepRose)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(expert, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text('$date at $time', style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppTheme.primaryRosePink),
                    foregroundColor: AppTheme.primaryRosePink,
                  ),
                  child: const Text('Reschedule'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Details'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
