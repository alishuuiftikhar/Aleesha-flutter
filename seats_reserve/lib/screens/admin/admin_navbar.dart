import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seats_reserve/providers/auth_provider.dart';
import 'package:seats_reserve/providers/data_provider.dart';
import 'package:seats_reserve/screens/admin/admin_dashboard.dart';
import 'package:seats_reserve/screens/admin/students_list_screen.dart';
import 'package:seats_reserve/screens/admin/daily_reservations_screen.dart';
import 'package:seats_reserve/screens/admin/reports_screen.dart';
import 'package:seats_reserve/screens/admin/admin_settings_screen.dart';
import 'package:seats_reserve/theme/app_theme.dart';

class AdminNavbar extends StatefulWidget {
  const AdminNavbar({super.key});

  @override
  State<AdminNavbar> createState() => _AdminNavbarState();
}

class _AdminNavbarState extends State<AdminNavbar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().userProfile;
      if (user != null) {
        context.read<DataProvider>().fetchInitialData(user.id, user.role);
      }
    });
  }

  final List<Widget> _screens = [
    const AdminDashboard(),
    const StudentsListScreen(),
    const DailyReservationsScreen(),
    const ReportsScreen(),
    const AdminSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Students'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Reservations'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
