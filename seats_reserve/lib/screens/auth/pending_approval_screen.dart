import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seats_reserve/providers/auth_provider.dart';
import 'package:seats_reserve/theme/app_theme.dart';

class PendingApprovalScreen extends StatelessWidget {
  const PendingApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.hourglass_empty,
              size: 100,
              color: AppTheme.accentColor,
            ),
            const SizedBox(height: 24),
            Text(
              'Account Pending Approval',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your account is waiting for admin approval. You will be able to reserve seats once approved.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () => context.read<AuthProvider>().fetchProfile(),
              child: const Text('Check Status'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => context.read<AuthProvider>().signOut(),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
