import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models.dart';
import 'theme.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isAdmin = false;
  bool _initialized = false;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final role = ModalRoute.of(context)?.settings.arguments as String?;
      _isAdmin = (role == 'teacher');
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isAdmin ? 'Teacher Registration' : 'Student Registration')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withAlpha(30),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isAdmin ? Icons.school_outlined : Icons.person_add_outlined, 
                  size: 64, 
                  color: AppColors.primary
                ),
                const SizedBox(height: 16),
                Text('Join SeatFlow', style: Theme.of(context).textTheme.displayLarge),
                Text(
                  _isAdmin ? 'Create your Teacher Account' : 'Create your Student Account',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 24),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
                        ),
                        validator: (v) => v!.isEmpty ? 'Enter name' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _idController,
                        decoration: InputDecoration(
                          labelText: _isAdmin ? 'Employee ID' : 'Student ID',
                          prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.primary),
                        ),
                        validator: (v) => v!.isEmpty ? 'Enter ID' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary),
                        ),
                        validator: (v) => v!.isEmpty ? 'Enter email' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.lock_outline, color: AppColors.primary),
                        ),
                        validator: (v) => v!.length < 6 ? 'Min 6 characters' : null,
                      ),
                      const SizedBox(height: 32),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _handleRegister,
                              child: const Text('Create Account'),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      final state = context.read<AppState>();
      final error = await state.register(
        _nameController.text,
        _idController.text,
        _emailController.text,
        _passwordController.text,
        _isAdmin ? UserRole.admin : UserRole.student,
      );

      if (mounted) {
        setState(() => _isLoading = false);
        if (error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${_isAdmin ? "Teacher" : "Student"} registration successful!')),
          );
          Navigator.pop(context);
        } else {
          // Display the ACTUAL error from Supabase
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text("Registration Error"),
              content: Text(error),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("OK"))
              ],
            ),
          );
        }
      }
    }
  }
}
