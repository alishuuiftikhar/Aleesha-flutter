import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_models.dart';
import '../providers/app_provider.dart';
import 'result_screen.dart';

class ExamTakingScreen extends StatefulWidget {
  final Exam exam;
  const ExamTakingScreen({super.key, required this.exam});

  @override
  State<ExamTakingScreen> createState() => _ExamTakingScreenState();
}

class _ExamTakingScreenState extends State<ExamTakingScreen> {
  int _currentQuestionIndex = 0;
  List<Question> _questions = [];
  Map<int, List<QuestionOption>> _questionOptions = {};
  Map<int, int> _selectedAnswers = {};
  bool _isLoading = true;
  late int _attemptId;

  late Timer _timer;
  int _secondsRemaining = 0;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.exam.durationMinutes * 60;
    _loadExamData();
  }

  void _loadExamData() async {
    final provider = Provider.of<AppProvider>(context, listen: false);
    _attemptId = await provider.startExam(widget.exam.id!);
    _questions = await provider.getQuestions(widget.exam.id!);
    
    for (var q in _questions) {
      _questionOptions[q.id!] = await provider.getOptions(q.id!);
    }

    setState(() => _isLoading = false);
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _submitExam(auto: true);
      }
    });
  }

  void _submitExam({bool auto = false}) async {
    if (!auto) {
      bool confirm = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Submit Exam?'),
              content: const Text('Are you sure you want to finish the exam?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Submit')),
              ],
            ),
          ) ??
          false;
      if (!confirm) return;
    }

    _timer.cancel();
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
    }

    final provider = Provider.of<AppProvider>(context, listen: false);
    final nav = Navigator.of(context);
    
    await provider.submitExam(_attemptId, _selectedAnswers, _questions);

    if (mounted) {
      nav.pop(); // Close loading
      nav.pushReplacement(
        MaterialPageRoute(builder: (context) => ResultScreen(attemptId: _attemptId)),
      );
    }
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_questions.isEmpty) return const Scaffold(body: Center(child: Text('No questions in this exam.')));

    final question = _questions[_currentQuestionIndex];
    final options = _questionOptions[question.id!] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exam.title),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                _formatTime(_secondsRemaining),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.yellowAccent),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / _questions.length,
            backgroundColor: Colors.grey[300],
            color: const Color(0xFFF9A825),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Question ${_currentQuestionIndex + 1}/${_questions.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Marks: ${question.marks}'),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.questionText,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 24),
                  ...options.map((opt) => RadioListTile<int>(
                        value: opt.id!,
                        groupValue: _selectedAnswers[question.id],
                        title: Text(opt.optionText),
                        onChanged: (val) {
                          setState(() => _selectedAnswers[question.id!] = val!);
                        },
                        activeColor: const Color(0xFF3949AB),
                        tileColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      )),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentQuestionIndex > 0)
                  ElevatedButton(
                    onPressed: () => setState(() => _currentQuestionIndex--),
                    child: const Text('Previous'),
                  )
                else
                  const SizedBox(width: 80),
                if (_currentQuestionIndex < _questions.length - 1)
                  ElevatedButton(
                    onPressed: () => setState(() => _currentQuestionIndex++),
                    child: const Text('Next'),
                  )
                else
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF9A825)),
                    onPressed: () => _submitExam(),
                    child: const Text('Finish'),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
