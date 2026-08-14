import 'dart:async';
import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/app_state.dart';

class CookingSessionScreen extends StatefulWidget {
  final Recipe recipe;
  const CookingSessionScreen({super.key, required this.recipe});

  @override
  State<CookingSessionScreen> createState() => _CookingSessionScreenState();
}

class _CookingSessionScreenState extends State<CookingSessionScreen> {
  int _currentStep = 0;
  Timer? _timer;
  int _secondsRemaining = 0;
  bool _isTimerRunning = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer(int minutes) {
    _timer?.cancel();
    setState(() {
      _secondsRemaining = minutes * 60;
      _isTimerRunning = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
        setState(() => _isTimerRunning = false);
        _showTimerFinished();
      }
    });
  }

  void _showTimerFinished() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Time is up for this step! ⏰'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 5),
      ),
    );
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Cooking Assistant', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: (_currentStep + 1) / widget.recipe.steps.length,
                  backgroundColor: Colors.blue.shade700,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                const SizedBox(height: 10),
                Text(
                  'Overall Progress: ${((_currentStep + 1) / widget.recipe.steps.length * 100).toInt()}%',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'STEP ${_currentStep + 1}',
                    style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 2),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Text(
                          widget.recipe.steps[_currentStep],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500, height: 1.5),
                        ),
                      ),
                    ),
                  ),
                  if (_isTimerRunning)
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          Text('Step Timer', style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.bold)),
                          Text(_formatTime(_secondsRemaining), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.timer_outlined, size: 18),
                        label: const Text('Start 5m Timer'),
                        onPressed: () => _startTimer(5),
                      ),
                      const SizedBox(width: 10),
                      ActionChip(
                        avatar: const Icon(Icons.timer_outlined, size: 18),
                        label: const Text('Start 10m Timer'),
                        onPressed: () => _startTimer(10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _currentStep > 0
                    ? ElevatedButton(
                        onPressed: () => setState(() => _currentStep--),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white24,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        child: const Row(
                          children: [Icon(Icons.arrow_back_ios, size: 16), Text(' Back')],
                        ),
                      )
                    : const SizedBox(width: 100),
                _currentStep < widget.recipe.steps.length - 1
                    ? ElevatedButton(
                        onPressed: () => setState(() {
                          _currentStep++;
                          _timer?.cancel();
                          _isTimerRunning = false;
                        }),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue.shade900,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        child: const Row(
                          children: [Text('Next Step '), Icon(Icons.arrow_forward_ios, size: 16)],
                        ),
                      )
                    : ElevatedButton(
                        onPressed: () => _showCompletionDialog(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent.shade400,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        child: const Text('Complete!', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog() {
    AppState().addToHistory(widget.recipe.id);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Icon(Icons.stars, color: Colors.amber, size: 50),
            SizedBox(height: 10),
            Text('Masterpiece Ready!'),
          ],
        ),
        content: const Text('You\'ve successfully completed all steps. Your dish looks amazing!', textAlign: TextAlign.center),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                Navigator.pop(context);
              },
              child: const Text('Back to Recipes'),
            ),
          ),
        ],
      ),
    );
  }
}
