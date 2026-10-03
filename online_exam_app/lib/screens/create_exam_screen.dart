import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/app_models.dart';

class CreateExamScreen extends StatefulWidget {
  const CreateExamScreen({super.key});

  @override
  State<CreateExamScreen> createState() => _CreateExamScreenState();
}

class _CreateExamScreenState extends State<CreateExamScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _categoryController = TextEditingController();
  final _durationController = TextEditingController();
  final _marksController = TextEditingController();

  void _saveExam() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<AppProvider>(context, listen: false);
      final exam = Exam(
        title: _titleController.text,
        description: _descController.text,
        category: _categoryController.text,
        durationMinutes: int.parse(_durationController.text),
        totalMarks: int.parse(_marksController.text),
        creatorId: provider.currentUser!.id!,
      );

      await provider.addExam(exam);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exam Created. Now add questions from dashboard.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Exam')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: _titleController, decoration: const InputDecoration(labelText: 'Exam Title'), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              TextFormField(controller: _descController, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
              const SizedBox(height: 12),
              TextFormField(controller: _categoryController, decoration: const InputDecoration(labelText: 'Category'), validator: (v) => v!.isEmpty ? 'Required' : null),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextFormField(controller: _durationController, decoration: const InputDecoration(labelText: 'Duration (Mins)'), keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: TextFormField(controller: _marksController, decoration: const InputDecoration(labelText: 'Total Marks'), keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _saveExam, child: const Text('Save Exam')),
            ],
          ),
        ),
      ),
    );
  }
}
