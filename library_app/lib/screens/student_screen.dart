import 'package:flutter/material.dart';
import '../services/database_helper.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<Map<String, dynamic>> _students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    final data = await DatabaseHelper.instance.fetchStudents();
    setState(() {
      _students = data;
    });
  }

  void _showStudentDialog({Map<String, dynamic>? student}) {
    final nameController = TextEditingController(text: student?['name'] ?? '');
    final rollController = TextEditingController(text: student?['roll_no'] ?? '');
    final deptController = TextEditingController(text: student?['department'] ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Student'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Student Name')),
            TextField(controller: rollController, decoration: const InputDecoration(labelText: 'Roll Number')),
            TextField(controller: deptController, decoration: const InputDecoration(labelText: 'Department')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.lightBlue, foregroundColor: Colors.white),
            onPressed: () async {
              if (nameController.text.isNotEmpty && rollController.text.isNotEmpty) {
                await DatabaseHelper.instance.insertStudent({
                  'name': nameController.text,
                  'roll_no': rollController.text,
                  'department': deptController.text,
                });
                _loadStudents();
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Students Record'), backgroundColor: Colors.lightBlue, foregroundColor: Colors.white),
      body: ListView.builder(
        itemCount: _students.length,
        itemBuilder: (context, index) {
          final s = _students[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.lightBlue, child: Icon(Icons.person, color: Colors.white)),
              title: Text(s['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Roll No: ${s['roll_no']} | Dept: ${s['department']}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  await DatabaseHelper.instance.deleteStudent(s['id']);
                  _loadStudents();
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        onPressed: () => _showStudentDialog(),
        child: const Icon(Icons.person_add),
      ),
    );
  }
}