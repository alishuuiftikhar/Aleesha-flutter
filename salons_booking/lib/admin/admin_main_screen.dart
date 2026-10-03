import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'admin_home_screen.dart';
import 'staff_management_screen.dart';
import 'admin_bookings_screen.dart';
import 'admin_services_screen.dart';
import 'admin_reports_screen.dart';
import '../customer/profile_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const AdminHomeScreen(),
    const AdminBookingsScreen(),
    const AdminServicesScreen(),
    const StaffManagementScreen(),
    const AdminReportsScreen(),
    const ProfileScreen(currentRole: 'admin'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryRosePink,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.book_online_outlined), label: 'Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.spa_outlined), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Staff'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}
