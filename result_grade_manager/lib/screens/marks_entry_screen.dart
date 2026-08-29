import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../database/db_helper.dart';
import '../models/student.dart';
import '../models/mark.dart';
import '../models/subject.dart';

class MarksEntryScreen extends StatefulWidget {
  final Student student;
  final int semesterId;
  const MarksEntryScreen({super.key, required this.student, required this.semesterId});

  @override
  State<MarksEntryScreen> createState() => _MarksEntryScreenState();
}

class _MarksEntryScreenState extends State<MarksEntryScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Subject> _subjects = [];
  List<Mark> _existingMarks = [];
  Map<int, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData() async {
    final subjects = await _dbHelper.getSubjects();
    final marks = await _dbHelper.getMarksForStudent(widget.student.id!, widget.semesterId);
    
    setState(() {
      _subjects = subjects;
      _existingMarks = marks;
      for (var subject in subjects) {
        final existingMark = marks.firstWhere(
          (m) => m.subjectId == subject.id,
          orElse: () => Mark(studentId: widget.student.id!, subjectId: subject.id!, semesterId: widget.semesterId, marksObtained: 0, maxMarks: 100),
        );
        _controllers[subject.id!] = TextEditingController(
          text: marks.any((m) => m.subjectId == subject.id) ? existingMark.marksObtained.toString() : '',
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBg,
      appBar: AppBar(
        title: const Text('Enter Marks', style: TextStyle(color: Colors.white, fontSize: 18)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _subjects.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No subjects found', style: AppTextStyles.body),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go back and add subjects'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  color: AppColors.secondaryBg,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Student: ${widget.student.name}', style: AppTextStyles.subHeading),
                      Text('Enter marks out of 100', style: AppTextStyles.label),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _subjects.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final subject = _subjects[index];
                      return Card(
                        color: AppColors.cardBg,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(subject.name, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                              ),
                              Expanded(
                                flex: 2,
                                child: TextField(
                                  controller: _controllers[subject.id],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Marks',
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _saveMarks,
                      child: const Text('Save All Marks', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _saveMarks() async {
    for (var subject in _subjects) {
      final marksText = _controllers[subject.id!]?.text ?? '';
      if (marksText.isNotEmpty) {
        final marksObtained = double.tryParse(marksText) ?? 0.0;
        final existing = _existingMarks.firstWhere(
          (m) => m.subjectId == subject.id,
          orElse: () => Mark(studentId: -1, subjectId: -1, semesterId: -1, marksObtained: 0, maxMarks: 0),
        );

        if (existing.studentId != -1) {
          // Update
          await _dbHelper.updateMark(Mark(
            id: existing.id,
            studentId: widget.student.id!,
            subjectId: subject.id!,
            semesterId: widget.semesterId,
            marksObtained: marksObtained,
            maxMarks: 100,
          ));
        } else {
          // Insert
          await _dbHelper.insertMark(Mark(
            studentId: widget.student.id!,
            subjectId: subject.id!,
            semesterId: widget.semesterId,
            marksObtained: marksObtained,
            maxMarks: 100,
          ));
        }
      }
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Marks saved successfully!'), backgroundColor: AppColors.accent),
      );
      Navigator.pop(context);
    }
  }
}
