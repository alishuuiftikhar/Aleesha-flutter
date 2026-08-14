import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reset Password',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryText),
            ),
            const SizedBox(height: 12),
            const Text(
              'Enter your email address and we will send you a link to reset your password.',
              style: TextStyle(color: AppTheme.secondaryText),
            ),
            const SizedBox(height: 40),
            const CustomTextField(
              label: 'Email Address',
              hint: 'Enter your email',
              icon: Icons.email_outlined,
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: 'Send Reset Link',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reset link sent to your email!')),
                );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
