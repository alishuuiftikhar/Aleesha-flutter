import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StaffHomeScreen extends StatelessWidget {
  const StaffHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.veryLightPink,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              _buildStatsGrid(),
              const SizedBox(height: 32),
              const Text(
                "Today's Sessions",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.deepRose),
              ),
              const SizedBox(height: 16),
              _buildTodaySessions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good Morning, Sarah ✨', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
            Text('Your Schedule Today', style: Theme.of(context).textTheme.headlineMedium),
          ],
        ),
        const CircleAvatar(
          radius: 25,
          backgroundImage: NetworkImage('https://images.unsplash.com/photo-1594744803329-e58b31de2177?auto=format&fit=crop&q=80&w=2574'),
        ),
      ],
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('Total Sessions', '12', Icons.calendar_month, Colors.blue),
        _buildStatCard('Pending', '3', Icons.pending_actions, Colors.orange),
        _buildStatCard('Completed', '8', Icons.check_circle, Colors.green),
        _buildStatCard('Earnings', '\$450', Icons.attach_money, Colors.purple),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTodaySessions() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(color: AppTheme.softRose, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    Text(index == 0 ? '10:00' : (index == 1 ? '11:30' : '02:00'), style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.deepRose)),
                    const Text('AM', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Hydrating Facial', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Customer: Jane Doe', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        );
      },
    );
  }
}
