import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'signup_screen.dart';
import '../customer/customer_main_screen.dart';
import '../staff/staff_main_screen.dart';
import '../admin/admin_main_screen.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  final String role;
  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() => _isLoading = true);

    try {
      debugPrint('Attempting login for: $email as ${widget.role}');
      final response = await _authService.signIn(email, password);

      if (!mounted) return;

      if (response != null && response.user != null) {
        // Optional: Verify role from metadata if you want to be strict
        final userRole = response.user!.userMetadata?['role_name'] ?? 'customer';
        debugPrint('User logged in with role metadata: $userRole');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Welcome back! ✨')),
        );

        // Navigate based on role
        Widget nextScreen;
        switch (widget.role.toLowerCase()) {
          case 'staff':
            nextScreen = const StaffMainScreen();
            break;
          case 'admin':
            nextScreen = const AdminMainScreen();
            break;
          case 'customer':
          default:
            nextScreen = const CustomerMainScreen();
        }

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => nextScreen),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint('Login error: $e');
      if (!mounted) return;
      
      String errorMessage = e.toString();
      if (errorMessage.contains('Invalid login credentials')) {
        errorMessage = 'Invalid email or password';
      } else if (errorMessage.contains('Email not confirmed')) {
        errorMessage = 'Please verify your email first';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: $errorMessage'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = 'Welcome Back';
    if (widget.role == 'staff') title = 'Staff Login';
    if (widget.role == 'admin') title = 'Admin Portal';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.deepRose),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue your beauty journey ✨',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              const SizedBox(height: 40),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter email';
                  if (!value.contains('@')) return 'Invalid email format';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                validator: (value) => (value == null || value.isEmpty) ? 'Please enter password' : null,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement forgot password
                  },
                  child: const Text('Forgot Password?', style: TextStyle(color: AppTheme.primaryRosePink)),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Login'),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SignupScreen(role: widget.role)),
                      );
                    },
                    child: const Text('Sign Up', style: TextStyle(color: AppTheme.primaryRosePink, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
