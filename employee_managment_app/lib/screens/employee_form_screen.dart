import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:employee_managment_app/database/db_helper.dart';
import 'package:employee_managment_app/models/employee.dart';
import 'package:employee_managment_app/models/department.dart';

class EmployeeFormScreen extends StatefulWidget {
  final Employee? employee;

  const EmployeeFormScreen({super.key, this.employee});

  @override
  State<EmployeeFormScreen> createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _salaryController;
  late TextEditingController _dateController;

  int? _selectedDepartmentId;
  String _selectedStatus = 'Active';
  List<Department> _departments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee?.name ?? '');
    _emailController = TextEditingController(text: widget.employee?.email ?? '');
    _phoneController = TextEditingController(text: widget.employee?.phone ?? '');
    _salaryController = TextEditingController(text: widget.employee?.salary.toString() ?? '');
    _dateController = TextEditingController(text: widget.employee?.joiningDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now()));
    _selectedDepartmentId = widget.employee?.departmentId;
    _selectedStatus = widget.employee?.status ?? 'Active';
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    final departments = await DatabaseHelper.instance.getAllDepartments();
    setState(() {
      _departments = departments;
      if (_selectedDepartmentId == null && departments.isNotEmpty) {
        _selectedDepartmentId = departments.first.id;
      }
      _isLoading = false;
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _saveEmployee() async {
    if (_formKey.currentState!.validate()) {
      final employee = Employee(
        id: widget.employee?.id,
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        departmentId: _selectedDepartmentId!,
        departmentName: '', // This is handled by DB helper joining table
        joiningDate: _dateController.text,
        salary: double.parse(_salaryController.text),
        status: _selectedStatus,
      );

      if (widget.employee == null) {
        await DatabaseHelper.instance.addEmployee(employee);
      } else {
        await DatabaseHelper.instance.updateEmployee(employee);
      }

      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employee == null ? 'Add Employee' : 'Edit Employee'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person)),
                      validator: (value) => value!.isEmpty ? 'Please enter name' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.email)),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value!.isEmpty ? 'Please enter email' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone)),
                      keyboardType: TextInputType.phone,
                      validator: (value) => value!.isEmpty ? 'Please enter phone' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      value: _selectedDepartmentId,
                      decoration: const InputDecoration(labelText: 'Department', prefixIcon: Icon(Icons.business)),
                      items: _departments.map((dept) {
                        return DropdownMenuItem(
                          value: dept.id,
                          child: Text(dept.name),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedDepartmentId = value),
                      validator: (value) => value == null ? 'Please select department' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _dateController,
                      decoration: const InputDecoration(labelText: 'Joining Date', prefixIcon: Icon(Icons.calendar_today)),
                      readOnly: true,
                      onTap: _selectDate,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _salaryController,
                      decoration: const InputDecoration(labelText: 'Monthly Salary', prefixIcon: Icon(Icons.attach_money)),
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Please enter salary' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedStatus,
                      decoration: const InputDecoration(labelText: 'Status', prefixIcon: Icon(Icons.info)),
                      items: ['Active', 'On Leave', 'Terminated'].map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedStatus = value!),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveEmployee,
                        child: const Text('SAVE EMPLOYEE', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
