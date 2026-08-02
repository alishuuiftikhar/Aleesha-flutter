import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'login_screen.dart';
import 'course_screen.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Portal Pro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await supabase.auth.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Instructor Control Panel', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                .animate().fadeIn(),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: const Icon(Icons.menu_book, color: Color(0xFF4682B4), size: 30),
                title: const Text('Manage Courses & Modules', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Create courses, assignments, attendance & marks'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CoursesScreen()),
                  );
                },
              ),
            ).animate().slideY(begin: 0.2, end: 0).fadeIn(),
          ],
        ),
      ),
    );
  }
}