import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_colors.dart';
import '../../services/auth_notifier.dart';
import '../admin/admin_dashboard.dart';
import '../../models/profile_model.dart';

class AdminLoginScreen extends ConsumerStatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  ConsumerState<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends ConsumerState<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _handleAdminLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    await ref.read(authProvider.notifier).signIn(email, password);
    
    if (!mounted) return;

    final authState = ref.read(authProvider);
    if (authState.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authState.error!)),
      );
    } else if (authState.profile != null) {
      if (authState.profile!.role == UserRole.admin) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AdminDashboard()),
        );
      } else {
        await ref.read(authProvider.notifier).signOut();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Access Denied: You are not an admin.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider).isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0.0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40.0),
              const Center(
                child: Icon(Icons.admin_panel_settings, size: 80.0, color: AppColors.primary),
              ),
              const SizedBox(height: 32.0),
              Text(
                'Admin Portal',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 8.0),
              Text(
                'Manage Glamora Beauty operations',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 48.0),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  hintText: 'Admin Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: isLoading ? null : _handleAdminLogin,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.mainText),
                child: isLoading
                    ? const SizedBox(height: 20.0, width: 20.0, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0))
                    : const Text('Admin Login'),
              ),
              const SizedBox(height: 24.0),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Back to Customer Login', style: TextStyle(color: AppColors.primary)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
