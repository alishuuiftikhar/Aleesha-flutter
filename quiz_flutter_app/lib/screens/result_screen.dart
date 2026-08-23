import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import '../models/history.dart';
import '../services/storage_service.dart';
import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  final String categoryName;
  final int score;
  final int totalQuestions;

  const ResultScreen({
    super.key,
    required this.categoryName,
    required this.score,
    required this.totalQuestions,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final StorageService _storageService = StorageService();
  int _highScore = 0;

  @override
  void initState() {
    super.initState();
    _saveAndLoadResult();
  }

  Future<void> _saveAndLoadResult() async {
    final history = QuizHistory(
      categoryName: widget.categoryName,
      score: widget.score,
      totalQuestions: widget.totalQuestions,
      date: DateTime.now(),
    );
    await _storageService.saveHistory(history);
    final highScore = await _storageService.getHighScore(widget.categoryName);
    setState(() {
      _highScore = highScore;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double percentage = (widget.score / widget.totalQuestions) * 100;
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'QUIZ COMPLETE',
                style: GoogleFonts.orbitron(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.accent, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.2),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      '${widget.score}',
                      style: GoogleFonts.orbitron(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    Text(
                      'OUT OF ${widget.totalQuestions}',
                      style: GoogleFonts.rajdhani(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Score: ${percentage.toStringAsFixed(0)}%',
                style: GoogleFonts.rajdhani(
                  fontSize: 24,
                  color: percentage >= 70 ? AppColors.correct : AppColors.wrong,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'High Score: $_highScore',
                style: GoogleFonts.rajdhani(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 60),
              _ResultButton(
                text: 'PLAY AGAIN',
                icon: Icons.replay,
                color: AppColors.primary,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 20),
              _ResultButton(
                text: 'HOME',
                icon: Icons.home,
                color: AppColors.cardBackground,
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ResultButton({
    required this.text,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          text,
          style: GoogleFonts.orbitron(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
      ),
    );
  }
}
