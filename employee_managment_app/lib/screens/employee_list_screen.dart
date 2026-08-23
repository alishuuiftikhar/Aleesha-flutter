import 'package:flutter/material.dart';
import 'package:employee_managment_app/database/db_helper.dart';
import 'package:employee_managment_app/models/employee.dart';
import 'package:employee_managment_app/models/department.dart';
import 'package:employee_managment_app/screens/employee_form_screen.dart';
import 'package:employee_managment_app/screens/employee_details_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  List<Employee> _employees = [];
  List<Department> _departments = [];
  int? _selectedDepartmentId;
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final employees = await DatabaseHelper.instance.getAllEmployees(
      query: _searchQuery,
      departmentId: _selectedDepartmentId,
    );
    final departments = await DatabaseHelper.instance.getAllDepartments();
    setState(() {
      _employees = employees;
      _departments = departments;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by name or email...',
                    prefixIcon: const Icon(Icons.search),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    fillColor: Colors.grey[900],
                  ),
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                    _loadData();
                  },
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: _selectedDepartmentId == null,
                        onSelected: (selected) {
                          setState(() => _selectedDepartmentId = null);
                          _loadData();
                        },
                      ),
                      ..._departments.map((dept) => Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: FilterChip(
                          label: Text(dept.name),
                          selected: _selectedDepartmentId == dept.id,
                          onSelected: (selected) {
                            setState(() => _selectedDepartmentId = selected ? dept.id : null);
                            _loadData();
                          },
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _employees.isEmpty
              ? const Center(child: Text('No employees found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _employees.length,
                  itemBuilder: (context, index) {
                    final employee = _employees[index];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF2ECC71),
                          child: Text(
                            employee.name[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(employee.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${employee.departmentName} • ${employee.status}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EmployeeDetailsScreen(employee: employee),
                          ),
                        ).then((_) => _loadData()),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2ECC71),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EmployeeFormScreen()),
        ).then((_) => _loadData()),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
