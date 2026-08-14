import 'dart:ui';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'search_screen.dart';
import 'watchlist_screen.dart';
import 'profile_screen.dart';

class CineMainScreen extends StatefulWidget {
  const CineMainScreen({super.key});

  @override
  State<CineMainScreen> createState() => _CineMainScreenState();
}

class _CineMainScreenState extends State<CineMainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const CineHomeScreen(),
    const SearchScreen(),
    const WatchlistScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        height: 70, // Reduced height as requested
        margin: const EdgeInsets.fromLTRB(25, 0, 25, 20), // Adjusted margin
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.85),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: const Color(0xFF5B21B6).withOpacity(isDark ? 0.3 : 0.1), 
                  width: 1.2
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (i) => setState(() => _currentIndex = i),
                backgroundColor: Colors.transparent,
                selectedItemColor: const Color(0xFF8B5CF6),
                unselectedItemColor: isDark 
                    ? const Color(0xFFC4B5FD).withOpacity(0.4) 
                    : Colors.grey[600],
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                elevation: 0,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.grid_view_rounded, size: 24),
                    label: 'Explore',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search_rounded, size: 24),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.auto_awesome_motion_rounded, size: 24),
                    label: 'List',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_rounded, size: 24),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
