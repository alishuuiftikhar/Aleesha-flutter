import 'package:flutter/material.dart';
import 'package:employee_managment_app/database/db_helper.dart';
import 'package:employee_managment_app/models/employee.dart';
import 'package:employee_managment_app/screens/employee_form_screen.dart';

class EmployeeDetailsScreen extends StatefulWidget {
  final Employee employee;

  const EmployeeDetailsScreen({super.key, required this.employee});

  @override
  State<EmployeeDetailsScreen> createState() => _EmployeeDetailsScreenState();
}

class _EmployeeDetailsScreenState extends State<EmployeeDetailsScreen> {
  late Employee _employee;

  @override
  void initState() {
    super.initState();
    _employee = widget.employee;
  }

  void _deleteEmployee() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Employee?'),
        content: const Text('Are you sure you want to delete this employee?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DatabaseHelper.instance.deleteEmployee(_employee.id!);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmployeeFormScreen(employee: _employee),
                ),
              );
              if (result == true) {
                // Refresh data if updated
                final updatedEmployees = await DatabaseHelper.instance.getAllEmployees();
                setState(() {
                  _employee = updatedEmployees.firstWhere((e) => e.id == _employee.id);
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _deleteEmployee,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Color(0xFF2ECC71),
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              _employee.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              _employee.departmentName,
              style: const TextStyle(fontSize: 18, color: Color(0xFF2ECC71)),
            ),
            const SizedBox(height: 32),
            _buildDetailCard(Icons.email, 'Email', _employee.email),
            _buildDetailCard(Icons.phone, 'Phone', _employee.phone),
            _buildDetailCard(Icons.calendar_today, 'Joining Date', _employee.joiningDate),
            _buildDetailCard(Icons.payments, 'Salary', '\$${_employee.salary.toStringAsFixed(2)}'),
            _buildDetailCard(Icons.info, 'Status', _employee.status),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(IconData icon, String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF2ECC71)),
        title: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
