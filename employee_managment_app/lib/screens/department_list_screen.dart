import 'package:flutter/material.dart';
import 'package:employee_managment_app/database/db_helper.dart';
import 'package:employee_managment_app/models/department.dart';

class DepartmentListScreen extends StatefulWidget {
  const DepartmentListScreen({super.key});

  @override
  State<DepartmentListScreen> createState() => _DepartmentListScreenState();
}

class _DepartmentListScreenState extends State<DepartmentListScreen> {
  List<Department> _departments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _refreshDepartments();
  }

  Future<void> _refreshDepartments() async {
    setState(() => _isLoading = true);
    final departments = await DatabaseHelper.instance.getAllDepartments();
    setState(() {
      _departments = departments;
      _isLoading = false;
    });
  }

  void _showDepartmentDialog([Department? department]) {
    final nameController = TextEditingController(text: department?.name ?? '');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(department == null ? 'Add Department' : 'Edit Department'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Department Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty) {
                if (department == null) {
                  await DatabaseHelper.instance.addDepartment(
                    Department(name: nameController.text),
                  );
                } else {
                  await DatabaseHelper.instance.updateDepartment(
                    Department(id: department.id, name: nameController.text),
                  );
                }
                if (mounted) Navigator.pop(context);
                _refreshDepartments();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteDepartment(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Department?'),
        content: const Text('This will delete all employees in this department. Are you sure?'),
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
      await DatabaseHelper.instance.deleteDepartment(id);
      _refreshDepartments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Departments')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _departments.length,
              itemBuilder: (context, index) {
                final dept = _departments[index];
                return Card(
                  child: ListTile(
                    title: Text(dept.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showDepartmentDialog(dept),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteDepartment(dept.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2ECC71),
        onPressed: () => _showDepartmentDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
