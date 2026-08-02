import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'add_course_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final supabase = Supabase.instance.client;
  String? userRole;
  bool isLoading = true;
  List<Map<String, dynamic>> courses = [];
  List<int> enrolledCourseIds = [];

  @override
  void initState() {
    super.initState();
    _fetchUserDataAndCourses();
  }

  Future<void> _fetchUserDataAndCourses() async {
    setState(() => isLoading = true);
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      // 1. Get User Role
      final userDoc = await supabase.from('users').select('role').eq('id', user.id).single();
      userRole = userDoc['role'];

      // 2. Fetch Courses
      final coursesRes = await supabase.from('courses').select('*, teachers(users(full_name))');
      courses = List<Map<String, dynamic>>.from(coursesRes);

      // 3. If student, fetch enrolled courses
      if (userRole == 'student') {
        final enrollRes = await supabase.from('enrollments').select('course_id').eq('student_id', user.id);
        enrolledCourseIds = List<int>.from(enrollRes.map((e) => e['course_id']));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _enrollCourse(int courseId) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      await supabase.from('enrollments').insert({
        'student_id': user.id,
        'course_id': courseId,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully enrolled in course!'), backgroundColor: Colors.green),
      );
      _fetchUserDataAndCourses(); // Refresh list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enrollment failed: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userRole == 'teacher' ? 'Manage Courses' : 'Available Courses'),
        actions: [
          if (userRole == 'teacher')
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddCourseScreen()),
                );
                if (result == true) {
                  _fetchUserDataAndCourses();
                }
              },
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : courses.isEmpty
          ? const Center(child: Text('No courses available.', style: TextStyle(color: Colors.white70)))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          final courseId = course['id'];
          final isEnrolled = enrolledCourseIds.contains(courseId);
          final teacherName = course['teachers']?['users']?['full_name'] ?? 'Unknown Teacher';

          return Card(
            color: const Color(0xFF1E293B),
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course['title'],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    course['description'] ?? 'No description provided.',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Instructor: $teacherName', style: const TextStyle(fontSize: 12, color: Color(0xFF60A5FA))),
                      if (userRole == 'student')
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isEnrolled ? Colors.green : const Color(0xFF3B82F6),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          onPressed: isEnrolled ? null : () => _enrollCourse(courseId),
                          child: Text(isEnrolled ? 'Enrolled' : 'Enroll'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}