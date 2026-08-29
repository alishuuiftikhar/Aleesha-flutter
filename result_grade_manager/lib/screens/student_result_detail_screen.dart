import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../database/db_helper.dart';
import '../models/student.dart';
import '../models/semester.dart';
import '../models/mark.dart';
import '../models/subject.dart';
import 'marks_entry_screen.dart';

class StudentResultDetailScreen extends StatefulWidget {
  final Student student;
  const StudentResultDetailScreen({super.key, required this.student});

  @override
  State<StudentResultDetailScreen> createState() => _StudentResultDetailScreenState();
}

class _StudentResultDetailScreenState extends State<StudentResultDetailScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Map<String, dynamic>> _summaries = [];
  List<Semester> _semesters = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    final summaries = await _dbHelper.getStudentSemesterSummary(widget.student.id!);
    final semesters = await _dbHelper.getSemesters();
    setState(() {
      _summaries = summaries;
      _semesters = semesters;
    });
  }

  String _calculateGrade(double percentage) {
    if (percentage >= 90) return 'A+';
    if (percentage >= 80) return 'A';
    if (percentage >= 70) return 'B';
    if (percentage >= 60) return 'C';
    if (percentage >= 50) return 'D';
    return 'F';
  }

  double _calculateGPA(double percentage) {
    return (percentage / 20) - 1 > 0 ? (percentage / 20) - 1 : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBg,
      appBar: AppBar(
        title: Text(widget.student.name, style: AppTextStyles.heading.copyWith(color: Colors.white, fontSize: 18)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Semester Results', style: AppTextStyles.subHeading),
                TextButton.icon(
                  onPressed: _showAddSemesterDialog,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add Semester'),
                  style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _summaries.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text('No marks entered yet. Tap "Enter Marks" to start.', style: AppTextStyles.body, textAlign: TextAlign.center),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _summaries.length,
                    itemBuilder: (context, index) {
                      final summary = _summaries[index];
                      final obtained = summary['total_obtained'] as double;
                      final max = summary['total_max'] as double;
                      final percentage = (obtained / max) * 100;
                      
                      return Card(
                        color: AppColors.cardBg,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: ExpansionTile(
                          title: Text(summary['semester_name'], style: AppTextStyles.subHeading.copyWith(fontSize: 16)),
                          subtitle: Text('${summary['subjects_count']} Subjects', style: AppTextStyles.label),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'GPA: ${_calculateGPA(percentage).toStringAsFixed(2)}',
                              style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold),
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  _buildResultRow('Total Marks', '${obtained.toInt()} / ${max.toInt()}'),
                                  _buildResultRow('Percentage', '${percentage.toStringAsFixed(1)}%'),
                                  _buildResultRow('Grade', _calculateGrade(percentage)),
                                  const Divider(),
                                  TextButton(
                                    onPressed: () => _navigateToMarksEntry(summary['semester_id']),
                                    child: const Text('View/Edit Detailed Marks'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_semesters.isEmpty) {
            _showAddSemesterDialog();
          } else {
            _showSemesterSelection();
          }
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.edit_note, color: Colors.white),
        label: const Text('Enter Marks', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.secondaryBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: AppColors.primary,
            child: Text(widget.student.name[0], style: const TextStyle(fontSize: 30, color: Colors.white)),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.student.name, style: AppTextStyles.heading.copyWith(fontSize: 22)),
                Text('Roll Number: ${widget.student.rollNumber}', style: AppTextStyles.body),
                Text('Grade: ${widget.student.grade}', style: AppTextStyles.body),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.label),
          Text(value, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showAddSemesterDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Semester'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'e.g. Semester 1, Final 2023'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await _dbHelper.insertSemester(Semester(name: controller.text));
                Navigator.pop(context);
                _loadData();
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showSemesterSelection() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Select Semester', style: AppTextStyles.subHeading),
            const SizedBox(height: 16),
            ..._semesters.map((sem) => ListTile(
              title: Text(sem.name),
              onTap: () {
                Navigator.pop(context);
                _navigateToMarksEntry(sem.id!);
              },
            )).toList(),
          ],
        ),
      ),
    );
  }

  void _navigateToMarksEntry(int semesterId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MarksEntryScreen(
          student: widget.student,
          semesterId: semesterId,
        ),
      ),
    ).then((_) => _loadData());
  }
}
