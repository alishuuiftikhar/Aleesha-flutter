import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MarksScreen extends StatefulWidget {
  final int courseId;
  final String courseTitle;

  const MarksScreen({super.key, required this.courseId, required this.courseTitle});

  @override
  State<MarksScreen> createState() => _MarksScreenState();
}

class _MarksScreenState extends State<MarksScreen> {
  final supabase = Supabase.instance.client;
  bool isLoading = true;
  String? userRole;
  List<Map<String, dynamic>> enrolledStudents = [];
  List<Map<String, dynamic>> assignments = [];
  List<Map<String, dynamic>> marksList = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => isLoading = true);
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final userDoc = await supabase.from('users').select('role').eq('id', user.id).single();
      userRole = userDoc['role'];

      // Fetch Assignments
      final assignRes = await supabase.from('assignments').select().eq('course_id', widget.courseId);
      assignments = List<Map<String, dynamic>>.from(assignRes);

      if (userRole == 'teacher') {
        // Fetch Enrolled Students for this course
        final studRes = await supabase
            .from('enrollments')
            .select('student_id, students(enrollment_no), users!inner(full_name)')
            .eq('course_id', widget.courseId);
        enrolledStudents = List<Map<String, dynamic>>.from(studRes);
      }

      // Fetch Marks
      final marksRes = await supabase.from('marks').select();
      marksList = List<Map<String, dynamic>>.from(marksRes);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _saveMarks(String studentId, int assignmentId, double obtained, double total) async {
    try {
      await supabase.from('marks').upsert({
        'student_id': studentId,
        'assignment_id': assignmentId,
        'obtained_marks': obtained,
        'total_marks': total,
      }, onConflict: 'assignment_id, student_id');

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Marks saved successfully!'), backgroundColor: Colors.green));
      _fetchData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Marks: ${widget.courseTitle}')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : userRole == 'teacher'
          ? ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: enrolledStudents.length,
        itemBuilder: (context, index) {
          final student = enrolledStudents[index];
          final studentId = student['student_id'];
          final studentName = student['users']['full_name'];

          return Card(
            color: const Color(0xFF1E293B),
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              title: Text(studentName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              subtitle: Text('Enrollment: ${student['students']['enrollment_no']}', style: const TextStyle(color: Colors.white70)),
              children: assignments.map((assign) {
                final existingMark = marksList.firstWhere(
                      (m) => m['student_id'] == studentId && m['assignment_id'] == assign['id'],
                  orElse: () => <String, dynamic>{},
                );

                final obtController = TextEditingController(text: existingMark['obtained_marks']?.toString() ?? '');
                final totController = TextEditingController(text: existingMark['total_marks']?.toString() ?? '10');

                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Expanded(flex: 2, child: Text(assign['title'], style: const TextStyle(color: Colors.white))),
                      const SizedBox(width: 10),
                      Expanded(child: TextField(controller: obtController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Obt'))),
                      const SizedBox(width: 10),
                      Expanded(child: TextField(controller: totController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Tot'))),
                      IconButton(
                        icon: const Icon(Icons.save, color: Color(0xFF3B82F6)),
                        onPressed: () {
                          final obt = double.tryParse(obtController.text) ?? 0;
                          final tot = double.tryParse(totController.text) ?? 10;
                          _saveMarks(studentId, assign['id'], obt, tot);
                        },
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: marksList.length,
        itemBuilder: (context, index) {
          final mark = marksList[index];
          return Card(
            color: const Color(0xFF1E293B),
            child: ListTile(
              title: Text('Marks: ${mark['obtained_marks']} / ${mark['total_marks']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
    );
  }
}