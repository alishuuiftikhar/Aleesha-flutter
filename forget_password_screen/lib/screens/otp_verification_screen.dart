import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:forget_password_screen/theme/app_theme.dart';
import 'package:forget_password_screen/screens/reset_password_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  const OTPVerificationScreen({super.key, required this.email});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _verifyOTP() {
    String otp = _controllers.map((e) => e.text).join();
    if (otp.length == 4) {
      // For demonstration, navigate to reset password
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
      );
    }
  }

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
              'Verification',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ).animate().fadeIn(),
            const SizedBox(height: 8),
            Text(
              'Enter the 4-digit code sent to ${widget.email}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                4,
                (index) => SizedBox(
                  width: 70,
                  height: 70,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      counterText: "",
                      fillColor: AppTheme.primaryColor.withOpacity(0.05),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        _focusNodes[index + 1].requestFocus();
                      } else if (value.isEmpty && index > 0) {
                        _focusNodes[index - 1].requestFocus();
                      }
                      if (index == 3 && value.isNotEmpty) {
                        _verifyOTP();
                      }
                    },
                  ),
                ),
              ).animate(interval: 100.ms).fadeIn().scale(),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: _verifyOTP,
              child: const Text('Verify Code'),
            ).animate().fadeIn(delay: 600.ms),
            const SizedBox(height: 24),
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Didn't receive code? Resend",
                  style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
