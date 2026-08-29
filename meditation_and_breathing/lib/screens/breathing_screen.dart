import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/app_colors.dart';

class BreathingPattern {
  final String name;
  final int inhale;
  final int hold;
  final int exhale;
  final int holdPost;

  BreathingPattern(this.name, this.inhale, this.hold, this.exhale, this.holdPost);
}

class BreathingScreen extends StatefulWidget {
  const BreathingScreen({super.key});

  @override
  State<BreathingScreen> createState() => _BreathingScreenState();
}

class _BreathingScreenState extends State<BreathingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  
  bool _isActive = false;
  int _secondsRemaining = 300;
  Timer? _timer;
  String _currentPhase = "Ready to start?";
  
  final List<BreathingPattern> _patterns = [
    BreathingPattern("Relax (4-7-8)", 4, 7, 8, 0),
    BreathingPattern("Box (4-4-4-4)", 4, 4, 4, 4),
    BreathingPattern("Equal (5-5)", 5, 0, 5, 0),
  ];
  late BreathingPattern _selectedPattern;
  
  @override
  void initState() {
    super.initState();
    _selectedPattern = _patterns[0];
    _initController();
  }

  void _initController() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _selectedPattern.inhale),
    );
    
    _sizeAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addStatusListener(_handleStatus);
  }

  void _handleStatus(AnimationStatus status) async {
    if (!_isActive) return;

    if (status == AnimationStatus.completed) {
      if (_selectedPattern.hold > 0) {
        setState(() => _currentPhase = "Hold...");
        HapticFeedback.mediumImpact();
        await Future.delayed(Duration(seconds: _selectedPattern.hold));
      }
      if (!_isActive) return;
      setState(() => _currentPhase = "Exhale slowly...");
      HapticFeedback.lightImpact();
      _controller.duration = Duration(seconds: _selectedPattern.exhale);
      _controller.reverse();
    } else if (status == AnimationStatus.dismissed) {
      if (_selectedPattern.holdPost > 0) {
        setState(() => _currentPhase = "Hold...");
        HapticFeedback.mediumImpact();
        await Future.delayed(Duration(seconds: _selectedPattern.holdPost));
      }
      if (!_isActive) return;
      setState(() => _currentPhase = "Inhale deeply...");
      HapticFeedback.lightImpact();
      _controller.duration = Duration(seconds: _selectedPattern.inhale);
      _controller.forward();
    }
  }

  void _toggleBreathing() {
    setState(() {
      _isActive = !_isActive;
      if (_isActive) {
        _currentPhase = "Inhale deeply...";
        HapticFeedback.heavyImpact();
        _controller.forward();
        _startTimer();
      } else {
        _currentPhase = "Paused";
        _controller.stop();
        _timer?.cancel();
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _toggleBreathing();
        _showCompletionDialog();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Great Job!'),
        content: const Text('You have completed your breathing exercise.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Breathing')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _currentPhase,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                children: _patterns.map((p) => ChoiceChip(
                  label: Text(p.name, style: TextStyle(fontSize: 10)),
                  selected: _selectedPattern == p,
                  onSelected: _isActive ? null : (val) {
                    if (val) setState(() {
                      _selectedPattern = p;
                      _controller.duration = Duration(seconds: p.inhale);
                    });
                  },
                )).toList(),
              ),
              const SizedBox(height: 30),
              AnimatedBuilder(
                animation: _sizeAnimation,
                builder: (context, child) {
                  return Container(
                    width: 250 * _sizeAnimation.value,
                    height: 250 * _sizeAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.4),
                          AppColors.secondary.withOpacity(0.2),
                          AppColors.secondaryBackground,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.2),
                          blurRadius: 30 * _sizeAnimation.value,
                          spreadRadius: 10 * _sizeAnimation.value,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.air, color: AppColors.primary, size: 50),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 30),
              Text(
                _formatTime(_secondsRemaining),
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _toggleBreathing,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(_isActive ? 'STOP' : 'START'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
