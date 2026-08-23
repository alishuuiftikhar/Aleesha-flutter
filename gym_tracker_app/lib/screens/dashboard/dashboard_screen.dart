import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';
import '../workout/workout_list_screen.dart';
import '../exercise/exercise_library_screen.dart';
import '../progress/progress_screen.dart';
import '../profile/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardHome(),
    const WorkoutListScreen(),
    const ExerciseLibraryScreen(),
    const ProgressScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.divider, width: 0.5)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: AppColors.mainBackground,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.secondaryText,
          selectedLabelStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.fitness_center_rounded), label: 'Workouts'),
            BottomNavigationBarItem(icon: Icon(Icons.explore_rounded), label: 'Exercises'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics_rounded), label: 'Progress'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
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
      backgroundColor: AppColors.mainBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.mainBackground,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              title: Text(
                'GYM TRACKER',
                style: GoogleFonts.bebasNeue(
                  fontSize: 28,
                  letterSpacing: 2,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HELLO, CHAMP!',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mainText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Ready to crush your goals today?',
                    style: GoogleFonts.poppins(color: AppColors.secondaryText),
                  ),
                  const SizedBox(height: 30),
                  _buildMainStats(),
                  const SizedBox(height: 30),
                  _buildSectionHeader('YOUR PLANS', () {}),
                  const SizedBox(height: 15),
                  _buildWorkoutCard('Heavy Push Day', '45 min', '8 Exercises', '0.8'),
                  const SizedBox(height: 15),
                  _buildWorkoutCard('Leg Destroyer', '60 min', '6 Exercises', '0.4'),
                  const SizedBox(height: 30),
                  _buildSectionHeader('RECENT ACTIVITY', () {}),
                  const SizedBox(height: 15),
                  _buildActivityTile('Back & Biceps', 'Yesterday, 6:00 PM'),
                  _buildActivityTile('Morning Cardio', '2 days ago, 7:30 AM'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainStats() {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem('75.4', 'Weight (kg)', Icons.monitor_weight_outlined, AppColors.accent),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildStatItem('12', 'Workouts', Icons.local_fire_department_rounded, AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildStatItem(String val, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 15),
          Text(val, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
          Text(label, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.secondaryText)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.bebasNeue(fontSize: 20, letterSpacing: 1.2, color: AppColors.mainText),
        ),
        TextButton(
          onPressed: onTap,
          child: const Text('See All', style: TextStyle(color: AppColors.primary)),
        ),
      ],
    );
  }

  Widget _buildWorkoutCard(String name, String time, String exercises, String progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.cardBackground, AppColors.cardBackground.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.fitness_center_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16)),
                Text('$time • $exercises', style: GoogleFonts.poppins(color: AppColors.secondaryText, fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.secondaryText),
        ],
      ),
    );
  }

  Widget _buildActivityTile(String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const CircleAvatar(
          backgroundColor: AppColors.cardBackground,
          child: Icon(Icons.history_rounded, size: 20, color: AppColors.secondaryText),
        ),
        title: Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle, style: GoogleFonts.poppins(fontSize: 12, color: AppColors.secondaryText)),
      ),
    );
  }
}
