import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seats_reserve/providers/auth_provider.dart';
import 'package:seats_reserve/providers/data_provider.dart';
import 'package:seats_reserve/screens/student/student_dashboard.dart';
import 'package:seats_reserve/screens/student/seat_selection_screen.dart';
import 'package:seats_reserve/screens/student/my_reservations_screen.dart';
import 'package:seats_reserve/screens/student/my_fines_screen.dart';
import 'package:seats_reserve/screens/student/profile_screen.dart';
import 'package:seats_reserve/theme/app_theme.dart';

class StudentNavbar extends StatefulWidget {
  const StudentNavbar({super.key});

  @override
  State<StudentNavbar> createState() => _StudentNavbarState();
}

class _StudentNavbarState extends State<StudentNavbar> {
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
    const StudentDashboard(),
    const SeatSelectionScreen(),
    const MyReservationsScreen(),
    const MyFinesScreen(),
    const StudentProfileScreen(),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.event_seat), label: 'Seats'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Reservations'),
          BottomNavigationBarItem(icon: Icon(Icons.money_off), label: 'Fines'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
