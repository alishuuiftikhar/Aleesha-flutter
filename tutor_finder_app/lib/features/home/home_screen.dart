import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/supabase_service.dart';
import '../booking/my_bookings_screen.dart';
import '../profile/profile_screen.dart';
import 'tutor_list_view.dart';
import '../dashboard/tutor_dashboard_view.dart';
import '../../models/profile_model.dart';
import '../../core/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  ProfileModel? _profile;
  bool _isLoading = true;
  final GlobalKey<MyBookingsScreenState> _bookingsKey = GlobalKey();
  final GlobalKey<TutorDashboardViewState> _dashboardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final service = context.read<SupabaseService>();
      final user = service.currentUser;
      if (user != null) {
        // Use a timeout to prevent infinite loading if network is slow
        final profile = await service.getProfile(user.id).timeout(const Duration(seconds: 10));
        if (mounted) {
          setState(() {
            _profile = profile;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint('Home Profile Load Error: $e');
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile. Please login again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final bool isTutor = _profile?.role == 'tutor';

    final List<Widget> children = [
      isTutor ? TutorDashboardView(key: _dashboardKey) : const TutorListView(),
      MyBookingsScreen(key: _bookingsKey),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: children,
      ),
      floatingActionButton: !isTutor && _currentIndex == 1
          ? FloatingActionButton.extended(
              onPressed: () {
                setState(() => _currentIndex = 0);
              },
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Book New Class', style: TextStyle(color: Colors.white)),
              backgroundColor: AppColors.primary,
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (index == 0 && isTutor) {
              _dashboardKey.currentState?.loadBookings();
            } else if (index == 1) {
              _bookingsKey.currentState?.loadBookings();
            }
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(isTutor ? Icons.dashboard : Icons.home),
            label: isTutor ? 'Dashboard' : 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Classes',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
