import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
      ],
      child: const LearningApp(),
    ),
  );
}

// ==================== STATE PROVIDERS ====================

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class Course {
  final String id;
  final String title;
  final String lessons;
  final String duration;
  final IconData icon;
  final String rating;
  bool isBookmarked;

  Course({
    required this.id,
    required this.title,
    required this.lessons,
    required this.duration,
    required this.icon,
    required this.rating,
    this.isBookmarked = false,
  });
}

class CourseProvider extends ChangeNotifier {
  final List<Course> _courses = [
    Course(id: '1', title: 'Flutter UI Masterclass', lessons: '24 Lessons', duration: '6 Hours', icon: Icons.phone_android, rating: '4.8'),
    Course(id: '2', title: 'Dart Clean Architecture', lessons: '18 Lessons', duration: '4 Hours', icon: Icons.code, rating: '4.9'),
  ];

  List<Course> get courses => _courses;
  List<Course> get bookmarkedCourses => _courses.where((c) => c.isBookmarked).toList();

  void toggleBookmark(String id) {
    final index = _courses.indexWhere((c) => c.id == id);
    if (index != -1) {
      _courses[index].isBookmarked = !_courses[index].isBookmarked;
      notifyListeners();
    }
  }
}

// ==================== MAIN APP ====================

class LearningApp extends StatelessWidget {
  const LearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Nexus E-Learning Pro',
      debugShowCheckedModeBanner: false,
      themeMode: themeProvider.themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB), brightness: Brightness.dark),
        scaffoldBackgroundColor: const Color(0xFF0F172A),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

// ==================== NAVIGATION ====================

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = const [
    LearningHomeScreen(),
    SavedScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_filled), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.bookmark_outline), selectedIcon: Icon(Icons.bookmark), label: 'Saved'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// ==================== HOME SCREEN ====================

class LearningHomeScreen extends StatelessWidget {
  const LearningHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome back,', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    SizedBox(height: 2),
                    Text('Master Flutter 🚀', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QuizScreen())),
                  icon: const Icon(Icons.quiz),
                  style: IconButton.styleFrom(backgroundColor: Theme.of(context).cardColor),
                ),
              ],
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const VideoPlayerScreen(title: 'Advanced State Management'))),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)]),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Continue Learning', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    SizedBox(height: 6),
                    Text('Advanced State Management', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 16),
                    LinearProgressIndicator(value: 0.65, backgroundColor: Colors.white24, color: Colors.amberAccent),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Recommended Courses', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: courseProvider.courses.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: CourseCard(course: courseProvider.courses[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== SAVED SCREEN ====================

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final saved = Provider.of<CourseProvider>(context).bookmarkedCourses;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bookmarked Courses', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            saved.isEmpty
                ? const Expanded(child: Center(child: Text('No saved courses yet!', style: TextStyle(color: Colors.grey))))
                : Expanded(
              child: ListView.builder(
                itemCount: saved.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 14.0),
                  child: CourseCard(course: saved[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== PROFILE SCREEN ====================

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const CircleAvatar(radius: 45, backgroundColor: Color(0xFF2563EB), child: Icon(Icons.person, size: 45, color: Colors.white)),
            const SizedBox(height: 16),
            const Text('Master Flutter', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('flutter.dev@nexus.com', style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 30),
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode, color: Color(0xFF2563EB)),
              title: const Text('Dark Mode'),
              value: themeProvider.isDarkMode,
              onChanged: (val) => themeProvider.toggleTheme(),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== VIDEO PLAYER SCREEN ====================

class VideoPlayerScreen extends StatelessWidget {
  final String title;
  const VideoPlayerScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 220,
            width: double.infinity,
            color: Colors.black,
            child: const Center(child: Icon(Icons.play_circle_filled, size: 64, color: Colors.white)),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.check_circle),
              label: const Text('Complete & Go Back'),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== QUIZ SCREEN ====================

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _selectedAnswer = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quick Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('What is the core building block of UI in Flutter?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            RadioListTile<int>(title: const Text('Widget'), value: 0, groupValue: _selectedAnswer, onChanged: (v) => setState(() => _selectedAnswer = v!)),
            RadioListTile<int>(title: const Text('Activity'), value: 1, groupValue: _selectedAnswer, onChanged: (v) => setState(() => _selectedAnswer = v!)),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
              onPressed: () => Navigator.pop(context),
              child: const Text('Submit Answer'),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== COURSE CARD COMPONENT ====================

class CourseCard extends StatelessWidget {
  final Course course;
  const CourseCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CourseProvider>(context, listen: false);
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VideoPlayerScreen(title: course.title))),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF2563EB).withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
              child: Icon(course.icon, color: const Color(0xFF2563EB)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(course.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 6),
                  Text('${course.lessons} • ${course.duration}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            IconButton(
              icon: Icon(course.isBookmarked ? Icons.bookmark : Icons.bookmark_border, color: const Color(0xFF2563EB)),
              onPressed: () => provider.toggleBookmark(course.id),
            ),
          ],
        ),
      ),
    );
  }
}