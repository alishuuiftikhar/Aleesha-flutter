import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../database/db_helper.dart';
import '../models/subject.dart';

class SubjectListScreen extends StatefulWidget {
  const SubjectListScreen({super.key});

  @override
  State<SubjectListScreen> createState() => _SubjectListScreenState();
}

class _SubjectListScreenState extends State<SubjectListScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Subject> _subjects = [];

  @override
  void initState() {
    super.initState();
    _refreshSubjects();
  }

  _refreshSubjects() async {
    final data = await _dbHelper.getSubjects();
    setState(() {
      _subjects = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBg,
      appBar: AppBar(
        title: Text('Subjects', style: AppTextStyles.heading.copyWith(color: Colors.white, fontSize: 20)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _subjects.isEmpty
          ? Center(child: Text('No subjects added yet', style: AppTextStyles.body))
          : ListView.builder(
              itemCount: _subjects.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                final subject = _subjects[index];
                return Card(
                  color: AppColors.cardBg,
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AppColors.secondaryBg, borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.book, color: AppColors.primary),
                    ),
                    title: Text(subject.name, style: AppTextStyles.subHeading.copyWith(fontSize: 16)),
                    subtitle: Text('Code: ${subject.code}', style: AppTextStyles.label),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: AppColors.accent),
                          onPressed: () => _showSubjectForm(subject: subject),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () => _deleteSubject(subject.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _showSubjectForm(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _showSubjectForm({Subject? subject}) {
    final nameController = TextEditingController(text: subject?.name ?? '');
    final codeController = TextEditingController(text: subject?.code ?? '');

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
            Text(subject == null ? 'Add Subject' : 'Edit Subject', style: AppTextStyles.subHeading),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Subject Name'),
            ),
            TextField(
              controller: codeController,
              decoration: const InputDecoration(labelText: 'Subject Code'),
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
                  final newSubject = Subject(
                    id: subject?.id,
                    name: nameController.text,
                    code: codeController.text,
                  );
                  if (subject == null) {
                    await _dbHelper.insertSubject(newSubject);
                  } else {
                    await _dbHelper.updateSubject(newSubject);
                  }
                  Navigator.pop(context);
                  _refreshSubjects();
                },
                child: Text(subject == null ? 'Save Subject' : 'Update Subject', style: const TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _deleteSubject(int id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Subject?'),
        content: const Text('Are you sure you want to delete this subject?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await _dbHelper.deleteSubject(id);
              Navigator.pop(context);
              _refreshSubjects();
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
