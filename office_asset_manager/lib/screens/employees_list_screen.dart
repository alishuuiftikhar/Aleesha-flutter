import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models.dart';
import '../supabase_service.dart';
import '../theme.dart';

class EmployeesListScreen extends StatefulWidget {
  const EmployeesListScreen({super.key});

  @override
  State<EmployeesListScreen> createState() => _EmployeesListScreenState();
}

class _EmployeesListScreenState extends State<EmployeesListScreen> {
  List<Employee> _employees = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    setState(() => _isLoading = true);
    try {
      final emps = await context.read<SupabaseService>().getEmployees();
      setState(() {
        _employees = emps;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addEmployee() async {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Employee'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Full Name')),
            const SizedBox(height: 16),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result == true && nameController.text.isNotEmpty && emailController.text.isNotEmpty) {
      try {
        await Supabase.instance.client.from('employees').insert({
          'full_name': nameController.text.trim(),
          'email': emailController.text.trim(),
        });
        _loadEmployees();
      } catch (e) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        actions: [
          IconButton(icon: const Icon(Icons.person_add), onPressed: _addEmployee),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _employees.isEmpty
              ? const Center(child: Text('No employees found'))
              : RefreshIndicator(
                  onRefresh: _loadEmployees,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _employees.length,
                    itemBuilder: (context, index) {
                      final emp = _employees[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: Text(emp.fullName[0], style: const TextStyle(color: Colors.white)),
                          ),
                          title: Text(emp.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(emp.email),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            // TODO: Show employee profile/assigned assets
                          },
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
