import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../services/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/login_screen.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Admin Dashboard', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.primary),
            onPressed: () async {
              await ref.read(authProvider.notifier).signOut();
              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Today’s Overview', style: GoogleFonts.playfairDisplay(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.mainText)),
              const SizedBox(height: 24),
              
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.4,
                children: [
                  _statCard('Total Revenue', r'$3,420', Icons.payments, Colors.green),
                  _statCard('Appointments', '24', Icons.calendar_month, AppColors.primary),
                  _statCard('New Customers', '12', Icons.people, Colors.blue),
                  _statCard('Pending', '8', Icons.hourglass_empty, Colors.orange),
                ],
              ),

              const SizedBox(height: 32),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Bookings', style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.mainText)),
                  TextButton(
                    onPressed: () {}, 
                    child: const Text('View All', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600))
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _bookingItem('Alice Johnson', 'Haircut', '10:00 AM', 'Confirmed'),
              _bookingItem('Mark Smith', 'Facial', '11:30 AM', 'Pending'),

              const SizedBox(height: 32),
              Text('Management', style: GoogleFonts.playfairDisplay(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.mainText)),
              const SizedBox(height: 16),
              _managementCard(Icons.auto_awesome, 'Manage Services', 'Add, Edit or Remove services'),
              _managementCard(Icons.face, 'Manage Stylists', 'Set schedules and availability'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 10.0,
            offset: const Offset(0, 4.0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28.0),
          const SizedBox(height: 8.0),
          Text(value, style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700, color: AppColors.mainText)),
          Text(label, style: const TextStyle(color: AppColors.secondaryText, fontSize: 12.0)),
        ],
      ),
    );
  }

  Widget _bookingItem(String name, String service, String time, String status) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.softRose, 
            child: Text(name[0], style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.mainText)),
                Text('$service • $time', style: const TextStyle(color: AppColors.secondaryText, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: status == 'Confirmed' ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status, 
              style: TextStyle(
                color: status == 'Confirmed' ? Colors.green : Colors.orange, 
                fontSize: 10, 
                fontWeight: FontWeight.w700
              )
            ),
          ),
        ],
      ),
    );
  }

  Widget _managementCard(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withValues(alpha: 0.02), blurRadius: 5),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: AppColors.softRose, shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.mainText)),
                Text(subtitle, style: const TextStyle(color: AppColors.secondaryText, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.primary),
        ],
      ),
    );
  }
}
