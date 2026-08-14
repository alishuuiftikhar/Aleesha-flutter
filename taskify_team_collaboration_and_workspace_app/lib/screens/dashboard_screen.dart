import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/task_card.dart';
import '../widgets/stat_card.dart';
import 'calendar_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';
import 'create_task_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardHome(),
    const CalendarScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateTaskScreen()),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home_rounded, color: _selectedIndex == 0 ? AppTheme.primaryColor : Colors.grey),
              onPressed: () => setState(() => _selectedIndex = 0),
            ),
            IconButton(
              icon: Icon(Icons.calendar_today_rounded, color: _selectedIndex == 1 ? AppTheme.primaryColor : Colors.grey),
              onPressed: () => setState(() => _selectedIndex = 1),
            ),
            const SizedBox(width: 40),
            IconButton(
              icon: Icon(Icons.chat_bubble_outline_rounded, color: _selectedIndex == 2 ? AppTheme.primaryColor : Colors.grey),
              onPressed: () => setState(() => _selectedIndex = 2),
            ),
            IconButton(
              icon: Icon(Icons.person_outline_rounded, color: _selectedIndex == 3 ? AppTheme.primaryColor : Colors.grey),
              onPressed: () => setState(() => _selectedIndex = 3),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Notifications clicked!')),
              );
            },
            icon: const Badge(
              label: Text('3'),
              child: Icon(Icons.notifications_none_rounded),
            ),
          ),
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hi, Aleesha 👋',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Your team has 5 tasks to complete today.',
              style: TextStyle(color: AppTheme.lightTextColor),
            ),
            const SizedBox(height: 24),
            const Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Tasks Done',
                    value: '12',
                    icon: Icons.check_circle_outline,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    title: 'In Progress',
                    value: '05',
                    icon: Icons.pending_outlined,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Current Projects',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Viewing all projects!')),
                    );
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  projectCard('Mobile App Redesign', 'Design Team', 0.75, Colors.purple),
                  projectCard('Taskify Branding', 'Marketing', 0.40, Colors.orange),
                  projectCard('Backend API', 'Dev Team', 0.90, Colors.blue),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Recent Tasks',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const TaskCard(
              title: 'Design System Update',
              category: 'Design',
              dueDate: 'Today',
              priority: 'High',
            ),
            const TaskCard(
              title: 'Fix Login Bug',
              category: 'Development',
              dueDate: 'Tomorrow',
              priority: 'Critical',
            ),
            const TaskCard(
              title: 'Social Media Assets',
              category: 'Marketing',
              dueDate: 'Aug 12',
              priority: 'Medium',
            ),
          ],
        ),
      ),
    );
  }

  Widget projectCard(String title, String team, double progress, Color color) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.rocket_launch, color: Colors.white, size: 20),
          ),
          const Spacer(),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(team, style: const TextStyle(color: AppTheme.lightTextColor, fontSize: 12)),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 4),
          Text('${(progress * 100).toInt()}% complete', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
