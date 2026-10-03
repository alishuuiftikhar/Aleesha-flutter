import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../models/app_models.dart';

class ManageQuestionsScreen extends StatefulWidget {
  final Exam exam;
  const ManageQuestionsScreen({super.key, required this.exam});

  @override
  State<ManageQuestionsScreen> createState() => _ManageQuestionsScreenState();
}

class _ManageQuestionsScreenState extends State<ManageQuestionsScreen> {
  List<Question> _questions = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  void _loadQuestions() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    final questions = await provider.getQuestions(widget.exam.id!);
    setState(() => _questions = questions);
  }

  void _addQuestion() {
    showDialog(
      context: context,
      builder: (context) => AddQuestionDialog(
        examId: widget.exam.id!,
        onAdded: _loadQuestions,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Questions: ${widget.exam.title}')),
      body: _questions.isEmpty
          ? const Center(child: Text('No questions added.'))
          : ListView.builder(
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final q = _questions[index];
                return ListTile(
                  title: Text(q.questionText),
                  subtitle: Text('Marks: ${q.marks}'),
                  trailing: const Icon(Icons.edit),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addQuestion,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddQuestionDialog extends StatefulWidget {
  final int examId;
  final VoidCallback onAdded;
  const AddQuestionDialog({super.key, required this.examId, required this.onAdded});

  @override
  State<AddQuestionDialog> createState() => _AddQuestionDialogState();
}

class _AddQuestionDialogState extends State<AddQuestionDialog> {
  final _qController = TextEditingController();
  final _marksController = TextEditingController(text: '1');
  final List<TextEditingController> _optionControllers = List.generate(4, (_) => TextEditingController());
  int _correctOptionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Question'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: _qController, decoration: const InputDecoration(labelText: 'Question Text')),
            TextField(controller: _marksController, decoration: const InputDecoration(labelText: 'Marks'), keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            const Text('Options', style: TextStyle(fontWeight: FontWeight.bold)),
            ...List.generate(4, (i) {
              return Row(
                children: [
                  Radio<int>(
                    value: i,
                    groupValue: _correctOptionIndex,
                    onChanged: (val) => setState(() => _correctOptionIndex = val!),
                  ),
                  Expanded(child: TextField(controller: _optionControllers[i], decoration: InputDecoration(labelText: 'Option ${i + 1}'))),
                ],
              );
            }),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            final provider = Provider.of<AppProvider>(context, listen: false);
            final nav = Navigator.of(context);
            final question = Question(
              examId: widget.examId,
              questionText: _qController.text,
              marks: int.parse(_marksController.text),
            );
            final options = List.generate(4, (i) => QuestionOption(
              questionId: 0, // Placeholder, provider will update
              optionText: _optionControllers[i].text,
              isCorrect: i == _correctOptionIndex ? 1 : 0,
            ));
            await provider.addQuestion(question, options);
            widget.onAdded();
            if (mounted) nav.pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
