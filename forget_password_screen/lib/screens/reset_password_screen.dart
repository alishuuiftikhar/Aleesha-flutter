import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:forget_password_screen/theme/app_theme.dart';
import 'package:forget_password_screen/screens/home_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reset Password',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ).animate().fadeIn(),
            const SizedBox(height: 8),
            Text(
              'Create a new password that is strong and unique.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 48),
            TextField(
              controller: _passwordController,
              obscureText: !_isVisible,
              decoration: InputDecoration(
                hintText: 'New Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_isVisible ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _isVisible = !_isVisible),
                ),
              ),
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 20),
            TextField(
              controller: _confirmPasswordController,
              obscureText: !_isVisible,
              decoration: const InputDecoration(
                hintText: 'Confirm New Password',
                prefixIcon: Icon(Icons.lock_reset),
              ),
            ).animate().fadeIn(delay: 500.ms),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Success feedback
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle, color: AppTheme.accentColor, size: 80),
                        const SizedBox(height: 24),
                        const Text(
                          'Password Reset Successfully!',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Your password has been updated. Please use your new password to login.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                              (route) => false,
                            );
                          },
                          child: const Text('Go to Home'),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: const Text('Reset Password'),
            ).animate().fadeIn(delay: 600.ms),
          ],
        ),
      ),
    );
  }
}
