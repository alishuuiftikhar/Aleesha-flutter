import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../customer/customer_main_screen.dart';
import '../staff/staff_main_screen.dart';
import '../admin/admin_main_screen.dart';

class SignupScreen extends StatefulWidget {
  final String role;
  const SignupScreen({super.key, required this.role});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isLoading = false;
  final _authService = AuthService();

  void _handleSignup() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        debugPrint('Attempting signup for email: ${_emailController.text.trim()} with role: ${widget.role}');
        
        final response = await _authService.signUp(
          _emailController.text.trim(),
          _passwordController.text.trim(),
          _nameController.text.trim(),
          widget.role,
          _phoneController.text.trim(),
        );

        if (!mounted) return;

        if (response != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Welcome to Glamora Beauty as ${widget.role}! ✨')),
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
        debugPrint('Signup error: $e');
        if (!mounted) return;
        
        String userFriendlyError = e.toString();
        if (userFriendlyError.contains('Database Trigger Error') || userFriendlyError.contains('Database error saving new user')) {
          userFriendlyError = 'Database Error: Please run the SQL script to create roles in Supabase dashboard.';
          _showSqlFixDialog();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(userFriendlyError),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 10),
            action: SnackBarAction(
              label: 'HELP',
              textColor: Colors.white,
              onPressed: () => _showSqlFixDialog(),
            ),
          ),
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      // Feedback for validation failure
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields correctly'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  void _showSqlFixDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Fix Database Error'),
        content: const SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Supabase database trigger is failing. Please run this SQL in your Supabase SQL Editor:', 
                style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              SelectableText(
                "INSERT INTO public.roles (name) VALUES ('admin'), ('staff'), ('customer') ON CONFLICT DO NOTHING;",
                style: TextStyle(fontFamily: 'monospace', backgroundColor: Colors.black12),
              ),
              SizedBox(height: 20),
              Text('Also, ensure your API Key in constants.dart starts with "eyJ...". Your current key looks like a Stripe key.'),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                'Create Account',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Join Glamora Beauty today ✨',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              const SizedBox(height: 30),
              _buildTextField(
                controller: _nameController,
                label: 'Full Name',
                icon: Icons.person_outline,
                validator: (value) => value!.trim().isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Please enter email';
                  if (!value.contains('@')) return 'Invalid email format';
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Icons.phone_outlined,
                validator: (value) => value!.trim().length < 10 ? 'Invalid phone (min 10 digits)' : null,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _passwordController,
                label: 'Password',
                icon: Icons.lock_outline,
                isPassword: true,
                isConfirmField: false,
                validator: (value) => value!.length < 6 ? 'Password too short (min 6 chars)' : null,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                icon: Icons.lock_outline,
                isPassword: true,
                isConfirmField: true,
                validator: (value) => value != _passwordController.text ? 'Passwords do not match' : null,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignup,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('Sign Up'),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Login', style: TextStyle(color: AppTheme.primaryRosePink, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool isConfirmField = false,
    String? Function(String?)? validator,
  }) {
    bool isVisible = isConfirmField ? _isConfirmPasswordVisible : _isPasswordVisible;
    
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !isVisible,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () => setState(() {
                  if (isConfirmField) {
                    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                  } else {
                    _isPasswordVisible = !_isPasswordVisible;
                  }
                }),
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
