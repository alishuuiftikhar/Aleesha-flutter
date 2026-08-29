import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../database/db_helper.dart';
import '../models/student.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Student> _students = [];
  List<Student> _filteredStudents = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshStudents();
  }

  _refreshStudents() async {
    final data = await _dbHelper.getStudents();
    setState(() {
      _students = data;
      _filteredStudents = data;
    });
  }

  void _filterStudents(String query) {
    setState(() {
      _filteredStudents = _students
          .where((s) => s.name.toLowerCase().contains(query.toLowerCase()) || 
                       s.rollNumber.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBg,
      appBar: AppBar(
        title: Text('Students', style: AppTextStyles.heading.copyWith(color: Colors.white, fontSize: 20)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or roll number...',
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.cardBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: _filterStudents,
            ),
          ),
          Expanded(
            child: _filteredStudents.isEmpty
                ? Center(child: Text('No students found', style: AppTextStyles.body))
                : ListView.builder(
                    itemCount: _filteredStudents.length,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      final student = _filteredStudents[index];
                      return Card(
                        color: AppColors.cardBg,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.secondaryBg,
                            child: Text(student.name[0].toUpperCase(), style: const TextStyle(color: AppColors.primary)),
                          ),
                          title: Text(student.name, style: AppTextStyles.subHeading.copyWith(fontSize: 16)),
                          subtitle: Text('Roll: ${student.rollNumber} | Grade: ${student.grade}', style: AppTextStyles.label),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: AppColors.accent),
                                onPressed: () => _showStudentForm(student: student),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.redAccent),
                                onPressed: () => _deleteStudent(student.id!),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showStudentForm(),
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }

  void _showStudentForm({Student? student}) {
    final nameController = TextEditingController(text: student?.name ?? '');
    final rollController = TextEditingController(text: student?.rollNumber ?? '');
    final gradeController = TextEditingController(text: student?.grade ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.mainBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(student == null ? 'Add Student' : 'Edit Student', style: AppTextStyles.subHeading),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: rollController,
              decoration: const InputDecoration(labelText: 'Roll Number'),
            ),
            TextField(
              controller: gradeController,
              decoration: const InputDecoration(labelText: 'Grade/Class'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  final newStudent = Student(
                    id: student?.id,
                    name: nameController.text,
                    rollNumber: rollController.text,
                    grade: gradeController.text,
                  );
                  if (student == null) {
                    await _dbHelper.insertStudent(newStudent);
                  } else {
                    await _dbHelper.updateStudent(newStudent);
                  }
                  Navigator.pop(context);
                  _refreshStudents();
                },
                child: Text(student == null ? 'Save Student' : 'Update Student', style: const TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _deleteStudent(int id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student?'),
        content: const Text('This will remove all their records. Are you sure?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await _dbHelper.deleteStudent(id);
              Navigator.pop(context);
              _refreshStudents();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
