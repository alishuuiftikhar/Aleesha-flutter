import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.veryLightPink,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Salon Overview',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.deepRose),
            ),
            const SizedBox(height: 20),
            _buildQuickStats(),
            const SizedBox(height: 32),
            _buildSectionHeader('Recent Bookings', () {}),
            const SizedBox(height: 16),
            _buildRecentBookings(),
            const SizedBox(height: 32),
            _buildSectionHeader('Top Performing Staff', () {}),
            const SizedBox(height: 16),
            _buildTopStaff(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildStatCard('Total Revenue', '\$12,450', Icons.payments, Colors.green)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard('Total Bookings', '1,240', Icons.book_online, Colors.blue)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildStatCard('Active Staff', '8', Icons.people, Colors.orange)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard('New Customers', '45', Icons.person_add, Colors.purple)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        TextButton(onPressed: onSeeAll, child: const Text('View All')),
      ],
    );
  }

  Widget _buildRecentBookings() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(backgroundColor: AppTheme.softRose, child: Icon(Icons.person, color: AppTheme.primaryRosePink)),
            title: const Text('Jane Doe', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Bridal Makeup • 02:00 PM'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
              child: const Text('Confirmed', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopStaff() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return Column(
            children: [
              const CircleAvatar(radius: 30, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1594744803329-e58b31de2177?auto=format&fit=crop&q=80&w=2574')),
              const SizedBox(height: 4),
              Text('Sarah ${index + 1}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          );
        },
      ),
    );
  }
}
