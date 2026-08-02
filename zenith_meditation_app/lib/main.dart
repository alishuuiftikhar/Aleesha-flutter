import 'package:flutter/material.dart';
import 'dart:async';

void main() => runApp(const MeditationApp());

class MeditationApp extends StatelessWidget {
  const MeditationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zenith Meditation',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF14B8A6),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF021E1D),
        fontFamily: 'Roboto',
      ),
      home: const MeditationHomeScreen(),
    );
  }
}

class MeditationHomeScreen extends StatefulWidget {
  const MeditationHomeScreen({super.key});

  @override
  State<MeditationHomeScreen> createState() => _MeditationHomeScreenState();
}

class _MeditationHomeScreenState extends State<MeditationHomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  bool _isSessionActive = false;
  bool _isAudioPlaying = false;
  String _breathText = 'Tap Circle to Begin';
  int _totalSeconds = 600; // 10 minutes default
  int _remainingSeconds = 600;
  Timer? _sessionTimer;
  String _selectedMood = 'Calm';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _scaleAnimation = Tween<double>(begin: 0.88, end: 1.12).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        setState(() => _breathText = 'Breathe In...');
      } else if (status == AnimationStatus.reverse) {
        setState(() => _breathText = 'Breathe Out...');
      }
    });
  }

  void _toggleSession() {
    setState(() {
      _isSessionActive = !_isSessionActive;
      if (_isSessionActive) {
        _animationController.repeat(reverse: true);
        _startTimer();
      } else {
        _animationController.stop();
        _animationController.reset();
        _sessionTimer?.cancel();
        _remainingSeconds = _totalSeconds;
        _breathText = 'Tap Circle to Begin';
      }
    });
  }

  void _startTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _toggleSession();
        _showCompletionDialog();
      }
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF0D3B3A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Session Complete 🌿', style: TextStyle(color: Colors.white)),
        content: const Text('Great job! You have successfully completed your mindfulness session.', style: TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue', style: TextStyle(color: Color(0xFF14B8A6))),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSecs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSecs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _animationController.dispose();
    _sessionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progressValue = 1.0 - (_remainingSeconds / _totalSeconds);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.spa, color: Color(0xFF5eead4), size: 18),
            SizedBox(width: 8),
            Text('ZENITH MIND', style: TextStyle(color: Color(0xFF5eead4), letterSpacing: 2.5, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isAudioPlaying ? Icons.volume_up : Icons.volume_off, color: const Color(0xFF5eead4)),
            onPressed: () {
              setState(() {
                _isAudioPlaying = !_isAudioPlaying;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isAudioPlaying ? 'Ambient Sounds Enabled 🎶' : 'Ambient Sounds Muted'),
                  duration: const Duration(seconds: 1),
                  backgroundColor: const Color(0xFF14B8A6),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Greeting & Mood Indicator
              const Text('How are you feeling today?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
              const SizedBox(height: 12),

              // Mood Selector Chips
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ['Calm', 'Stressed', 'Anxious', 'Tired'].map((mood) {
                  bool isSelected = _selectedMood == mood;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(mood),
                      selected: isSelected,
                      selectedColor: const Color(0xFF14B8A6),
                      backgroundColor: const Color(0xFF0D3B3A),
                      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white70, fontSize: 12),
                      onSelected: (selected) {
                        setState(() => _selectedMood = mood);
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 28),

              // Interactive Breathing Circle with Circular Progress Indicator
              GestureDetector(
                onTap: _toggleSession,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer Circular Progress
                    SizedBox(
                      height: 210,
                      width: 210,
                      child: CircularProgressIndicator(
                        value: progressValue,
                        strokeWidth: 4,
                        backgroundColor: Colors.white12,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF14B8A6)),
                      ),
                    ),
                    // Animated Inner Circle
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        height: 185,
                        width: 185,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF14B8A6).withOpacity(0.3),
                              const Color(0xFF0D3B3A),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(color: const Color(0xFF5eead4), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF14B8A6).withOpacity(0.25),
                              blurRadius: 30,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _formatTime(_remainingSeconds),
                                style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                _breathText,
                                style: const TextStyle(color: Color(0xFF5eead4), fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Primary Action Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF14B8A6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 6,
                    shadowColor: const Color(0xFF14B8A6).withOpacity(0.5),
                  ),
                  onPressed: _toggleSession,
                  child: Text(
                    _isSessionActive ? 'Pause / End Session' : 'Start Mindfulness Session',
                    style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Categories Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Curated Sessions', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('See all', style: TextStyle(color: Color(0xFF5eead4), fontSize: 12)),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 105,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _CategoryCard(title: 'Deep Sleep', subtitle: '15 mins • Ambient', icon: Icons.nightlight_round, color: Color(0xFF0F2C59)),
                    SizedBox(width: 12),
                    _CategoryCard(title: 'Stress Relief', subtitle: '10 mins • Breath', icon: Icons.spa, color: Color(0xFF0D3B3A)),
                    SizedBox(width: 12),
                    _CategoryCard(title: 'Focus Flow', subtitle: '20 mins • Alpha', icon: Icons.bolt, color: Color(0xFF381B38)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _CategoryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 145,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF5eead4), size: 22),
          const Spacer(),
          Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 2),
          Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 10)),
        ],
      ),
    );
  }
}