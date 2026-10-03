import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import 'dashboard_screen.dart';
import '../ideas/ideas_list_screen.dart';
import '../team/team_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';

/// Root authenticated shell with bottom navigation.
/// Tabs adapt slightly based on the logged-in user's role.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final isStudent = user?.role == UserRole.student;

    final screens = [
      const DashboardScreen(),
      const IdeasListScreen(),
      if (isStudent) const TeamScreen(),
      const NotificationsScreen(),
      const ProfileScreen(),
    ];

    final unread = context.watch<NotificationProvider>().unreadCount;

    final items = [
      const BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), activeIcon: Icon(Icons.dashboard), label: 'Dashboard'),
      const BottomNavigationBarItem(icon: Icon(Icons.lightbulb_outline), activeIcon: Icon(Icons.lightbulb), label: 'Ideas'),
      if (isStudent) const BottomNavigationBarItem(icon: Icon(Icons.groups_outlined), activeIcon: Icon(Icons.groups), label: 'Team'),
      BottomNavigationBarItem(
        icon: Badge(
          isLabelVisible: unread > 0,
          label: Text('$unread'),
          child: const Icon(Icons.notifications_outlined),
        ),
        activeIcon: const Icon(Icons.notifications),
        label: 'Alerts',
      ),
      const BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profile'),
    ];

    final safeIndex = _index >= screens.length ? 0 : _index;

    return Scaffold(
      body: IndexedStack(index: safeIndex, children: screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: safeIndex,
        onTap: (i) => setState(() => _index = i),
        items: items,
      ),
    );
  }
}
