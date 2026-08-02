import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AssignmentsScreen extends StatefulWidget {
  final int courseId;
  final String courseTitle;

  const AssignmentsScreen({super.key, required this.courseId, required this.courseTitle});

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  final supabase = Supabase.instance.client;
  List<Map<String, dynamic>> assignments = [];
  bool isLoading = true;
  String? userRole;

  @override
  void initState() {
    super.initState();
    _fetchAssignments();
  }

  Future<void> _fetchAssignments() async {
    setState(() => isLoading = true);
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final userDoc = await supabase.from('users').select('role').eq('id', user.id).single();
      userRole = userDoc['role'];

      final res = await supabase
          .from('assignments')
          .select()
          .eq('course_id', widget.courseId)
          .order('created_at', ascending: false);

      assignments = List<Map<String, dynamic>>.from(res);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _showAddAssignmentDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Add Assignment', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
            const SizedBox(height: 10),
            TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.trim().isEmpty) return;
              await supabase.from('assignments').insert({
                'course_id': widget.courseId,
                'title': titleController.text.trim(),
                'description': descController.text.trim(),
              });
              Navigator.pop(context);
              _fetchAssignments();
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Assignments: ${widget.courseTitle}')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : assignments.isEmpty
          ? const Center(child: Text('No assignments found.', style: TextStyle(color: Colors.white70)))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: assignments.length,
        itemBuilder: (context, index) {
          final item = assignments[index];
          return Card(
            color: const Color(0xFF1E293B),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              subtitle: Text(item['description'] ?? 'No description', style: const TextStyle(color: Colors.white70)),
              trailing: const Icon(Icons.assignment, color: Color(0xFF3B82F6)),
            ),
          );
        },
      ),
      floatingActionButton: userRole == 'teacher'
          ? FloatingActionButton(
        backgroundColor: const Color(0xFF3B82F6),
        onPressed: _showAddAssignmentDialog,
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,
    );
  }
}