import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../database/db_helper.dart';
import '../models/student.dart';
import 'student_result_detail_screen.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Student> _students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  _loadStudents() async {
    final data = await _dbHelper.getStudents();
    setState(() {
      _students = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBg,
      appBar: AppBar(
        title: Text('Student Results', style: AppTextStyles.heading.copyWith(color: Colors.white, fontSize: 20)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _students.isEmpty
          ? Center(child: Text('Add students first to view results', style: AppTextStyles.body))
          : ListView.builder(
              itemCount: _students.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final student = _students[index];
                return Card(
                  color: AppColors.cardBg,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.accent.withOpacity(0.1),
                      child: const Icon(Icons.assignment_turned_in, color: AppColors.accent),
                    ),
                    title: Text(student.name, style: AppTextStyles.subHeading.copyWith(fontSize: 16)),
                    subtitle: Text('Roll: ${student.rollNumber}', style: AppTextStyles.label),
                    trailing: const Icon(Icons.chevron_right, color: AppColors.secondary),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentResultDetailScreen(student: student),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
