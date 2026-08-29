import 'package:flutter/material.dart';
import '../../services/supabase_service.dart';
import '../../utils/constants.dart';
import '../seeker/seeker_main_screen.dart';
import '../employer/employer_main_screen.dart';

class DualLoginScreen extends StatefulWidget {
  final String targetRole;
  const DualLoginScreen({super.key, required this.targetRole});

  @override
  State<DualLoginScreen> createState() => _DualLoginScreenState();
}

class _DualLoginScreenState extends State<DualLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  Future<void> _process() async {
    if (!_isLogin && _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter name')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      if (_isLogin) {
        final response = await SupabaseService.signIn(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );
        // Check if role matches target
        final profile = await SupabaseService.getProfile(response.user!.id);
        if (profile != null && profile['role'] != widget.targetRole) {
          await SupabaseService.updateProfile(response.user!.id, {'role': widget.targetRole});
        }
      } else {
        await SupabaseService.signUp(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          {
            'full_name': _nameController.text.trim(),
            'role': widget.targetRole,
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Verification sent! Please check email.')));
        setState(() => _isLogin = true);
        setState(() => _isLoading = false);
        return;
      }

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => widget.targetRole == 'employer' 
            ? const EmployerMainScreen() 
            : const SeekerMainScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login as ${widget.targetRole.toUpperCase()}')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Text(
                _isLogin ? 'Switch to ${widget.targetRole}' : 'Register as ${widget.targetRole}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              if (!_isLogin) ...[
                TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Full Name', border: OutlineInputBorder())),
                const SizedBox(height: 16),
              ],
              TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder())),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _process,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : Text(_isLogin ? 'Login & Switch' : 'Sign Up as ${widget.targetRole}'),
              ),
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(_isLogin ? 'New here? Create ${widget.targetRole} account' : 'Already have an account? Login'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
